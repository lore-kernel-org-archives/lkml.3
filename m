Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3FQPWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:22:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22628 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3FQPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:22:36 -0400
Date: Mon, 17 Jun 2013 18:20:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Michael Banken <michael.banken@mathe.stud.uni-erlangen>
Subject: Re: [PATCH 2/5] silicom: checkpatch: fixed whitespace errors
Message-ID: <20130617152055.GE5008@mwanda>
References: <1371478817-28357-1-git-send-email-lorenz@badgers.com>
 <1371478817-28357-2-git-send-email-lorenz@badgers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371478817-28357-2-git-send-email-lorenz@badgers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 04:20:14PM +0200, Lorenz Haspel wrote:
> started cleanfile
> also fixed some other whitespace errors cleanfile didn't find
> 
> Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen>
> Signed-off-by: Lorenz Haspel <lorenz@badgers.com>

I assume this came from Michael Banken?  The first line of the body
of the email should say:

From: Michael Banken <michael.banken@mathe.stud.uni-erlangen>

so that git assigns credit properly.  Also the ".de" is missing from
that email.

This patch doesn't apply because someone just did some work on that
file.

Please resend the whole patch so it applies to linux-next and
assigns credit correctly.

regards,
dan carpenter


