Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3FQRjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:39:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31607 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3FQRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:12 -0400
Date: Mon, 17 Jun 2013 20:34:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/4] silicom: checkpatch: assignments in if conditions
Message-ID: <20130617173449.GK5008@mwanda>
References: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
 <20130617172246.GI5008@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617172246.GI5008@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, when you redo this one, you can probably just send this one by
itself as a reply to the original email without resending the other
3.  There is an in-reply-to option in git send.  I use mutt so I
don't know the details.

1)  Subject should be:

Subject: [PATCH 1/4 v2] silicom: checkpatch: assignments in if conditions

2) After the signed-off-by lines put:

signed-off-by: you
---
v2: removed some buggy extra lines and fixed white space issues

regards,
dan carpenter

