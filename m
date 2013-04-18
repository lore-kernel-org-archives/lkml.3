Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968Ab3DRRsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:48:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23636 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3DRRsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:48:30 -0400
Date: Thu, 18 Apr 2013 20:48:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: sameo@linux.intel.com, mchehab@redhat.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] radio-si476x: Fix incorrect pointer checking
Message-ID: <20130418174815.GB26896@mwanda>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
 <1366304318-29620-13-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366304318-29620-13-git-send-email-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 09:58:38AM -0700, Andrey Smirnov wrote:
> Fix incorrect pointer checking and make some minor code improvements:
> 
> * Remove unnecessary elements from function pointer table(vtable),
>   that includes all the elements that are FM-only, this allows for not
>   checking of the fucntion pointer and calling of the function
>   directly(THe check if the tuner is in FM mode has to be done anyway)
> 
> * Fix incorrect function pointer checking where the code would check one
>   pointer to be non-NULL, but would use other pointer, which would not
>   be checked.
> 
> * Remove code duplication in "si476x_radio_read_rsq_blob" and
>   "si476x_radio_read_rsq_primary_blob".
> 
> * Add some BUG_ON statements for function pointers that should never be NULL
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This should be a Reported-by for me, probably.

regards,
dan carpenter

