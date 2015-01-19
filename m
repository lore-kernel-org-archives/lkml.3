Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbbASScs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:32:48 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49511 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbbASScq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:32:46 -0500
Date: Mon, 19 Jan 2015 10:32:42 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] MTD: Deletion of checks before the function call
 "iounmap"
Message-ID: <20150119183242.GJ9759@ld-irv-0074>
References: <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54BBE87C.9020705@users.sourceforge.net>
 <20150119175835.GH9759@ld-irv-0074>
 <20150119182047.GG6456@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119182047.GG6456@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 09:20:47PM +0300, Dan Carpenter wrote:
> The sparc iounmap() implementation in arch/sparc/kernel/ioport.c looks
> it prints an error message if you pass a NULL pointer.

Seems that way. Thanks.

Nak to the patch then.

Brian
