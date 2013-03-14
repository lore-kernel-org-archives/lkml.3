Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab3CNLAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:00:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41927 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab3CNLAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:00:08 -0400
Date: Thu, 14 Mar 2013 13:59:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ccg: remove two outdated dependencies
Message-ID: <20130314105953.GJ9138@mwanda>
References: <1363256224.1335.46.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363256224.1335.46.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:17:04AM +0100, Paul Bolle wrote:
> 1) This patch is rather hard to review. That is because the "depends on"
> line is rather hard to read. Perhaps the easiest way to review is to do
>     git grep -n "\bUSB_FILE_STORAGE\(_TEST\)\?\b"
> 
> before and after applying this patch. But that doesn't catch possible
> other, unwanted, changes. Maybe we need to split up the "depends on"
> line before removing these two negative entries.

Your patch is fine as is, but if you wanted to send a follow on
patch to break the depend mess into separate lines, that would also
be welcome.  :)

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter


