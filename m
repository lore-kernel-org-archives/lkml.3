Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab3CLK5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:57:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29126 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab3CLK5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:57:02 -0400
Date: Tue, 12 Mar 2013 13:56:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mirsal Ennaime <mirsal@mirsal.fr>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 0/4] Cosmetic changes to the android binder proc
 release code
Message-ID: <20130312105641.GE9138@mwanda>
References: <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
 <1363084922-19698-1-git-send-email-mirsal@mirsal.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363084922-19698-1-git-send-email-mirsal@mirsal.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:41:58AM +0100, Mirsal Ennaime wrote:
> Changes from v2
> 
>  * kept arguments aligned with parentesis (Following
>    Arve Hjønnevåg's review)
>  * added a fourth patch which removes function names from string litterals
>    in favor __func__ (Following Dan Carpenter's review)

Actually that was Joe.

Looks good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

