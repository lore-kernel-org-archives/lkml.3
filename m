Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaLBN4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:56:44 -0500
Received: from tex.lwn.net ([70.33.254.29]:59821 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbaLBN4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:56:42 -0500
Date: Tue, 2 Dec 2014 08:56:39 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
Message-ID: <20141202085639.43080af0@lwn.net>
In-Reply-To: <alpine.DEB.2.10.1412021007560.2483@hadrien>
References: <20141202085950.GA13434@mwanda>
	<alpine.DEB.2.10.1412021007560.2483@hadrien>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 10:09:02 +0100 (CET)
Julia Lawall <julia.lawall@lip6.fr> wrote:

> kmalloc actually takes two arguments.  Perhaps it would be better to show
> something that looks like a valid call.

Agreed; I took the liberty of sticking in a GFP_KERNEL as I applied the
patch with Julia's ack.

Thanks,

jon
