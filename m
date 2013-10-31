Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3JaVJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 17:09:16 -0400
Received: from tex.lwn.net ([70.33.254.29]:34725 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3JaVJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 17:09:14 -0400
Date: Thu, 31 Oct 2013 15:09:12 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH -next] media/platform/marvell-ccic: fix cafe_ccic build
 error
Message-ID: <20131031150912.099a9d36@lwn.net>
In-Reply-To: <52729C60.6000408@infradead.org>
References: <20131031210027.cb3604b9589e0b7a1599dbd2@canb.auug.org.au>
	<52729C60.6000408@infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 11:07:28 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> The cafe_ccic driver (the mcam-core.c part of it) uses dma_sg
> interfaces so it needs to select VIDEOBUF2_DMA_SG to prevent
> build errors.

Geert sent a patch too a little while back.

BUT, this shouldn't be happening.  Could you send a .config file that
evokes this failure?  All of the s/g stuff is ifdeffed out if
VIDEOBUF2_DMA_SG isn't enabled...or it used to be...  I'd rather figure
out what's going on and not drag the s/g stuff into OLPC XO builds, where
memory is tight and there's no use for it.

(Sorry, I'm *way* behind on everything...)

Thanks,

jon
