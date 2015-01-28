Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbbA2D4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:56:02 -0500
Received: from tex.lwn.net ([70.33.254.29]:35864 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbbA2BKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:10:51 -0500
Date: Wed, 28 Jan 2015 14:58:43 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] [media] marvell-ccic needs VIDEOBUF2_DMA_SG
Message-ID: <20150128145843.16683733@lwn.net>
In-Reply-To: <1422479867-3370921-8-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
	<1422479867-3370921-8-git-send-email-arnd@arndb.de>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 22:17:47 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> The vb2_dma_sg_memops pointer is only valid if VIDEOBUF2_DMA_SG is
> set, so we should select that to avoid this build error:
> 
> drivers/built-in.o: In function `mcam_v4l_open':
> :(.text+0x388d00): undefined reference to `vb2_dma_sg_memops'

I acked this one the last time it came around (I forget from who).  I
still don't know how to create a .config that exposes the problem, but
others have clearly succeeded in doing it.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
