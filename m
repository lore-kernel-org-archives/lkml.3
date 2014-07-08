Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaGHLtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:49:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20635 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaGHLtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:49:14 -0400
Date: Tue, 8 Jul 2014 14:49:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Larry.Finger@lwfinger.net,
        linux-kernel@vger.kernel.org, drivers_staging@kernel-bugs.osdl.org
Subject: Re: [PATCH] staging: rtl8192ee: Correct bitmask in comparsion
Message-ID: <20140708114906.GN25880@mwanda>
References: <1404517213-4067-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404517213-4067-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 02:40:13AM +0300, Andrey Utkin wrote:
> See https://bugzilla.kernel.org/show_bug.cgi?id=78041
> ---8<---
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Following the link to bugzilla, this is a static checker fix.

As far as I can see this patch is just based on guess work?  Otherwise
put some kind of description why your fix is correct in the changelog.

regards,
dan carpenter

