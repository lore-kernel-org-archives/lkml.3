Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaKRNDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:03:20 -0500
Received: from tex.lwn.net ([70.33.254.29]:37059 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbaKRNDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:03:19 -0500
Date: Tue, 18 Nov 2014 08:03:17 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] media: marvell-ccic: use
 vb2_ops_wait_prepare/finish helper
Message-ID: <20141118080317.73b6b29e@lwn.net>
In-Reply-To: <1416309821-5426-7-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
	<1416309821-5426-7-git-send-email-prabhakar.csengg@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 11:23:35 +0000
"Lad, Prabhakar" <prabhakar.csengg@gmail.com> wrote:

>  drivers/media/platform/marvell-ccic/mcam-core.c | 29 +++++--------------------
>  1 file changed, 5 insertions(+), 24 deletions(-)

So I'm not convinced that this patch improves things; it moves a tiny bit
of code into another file where anybody reading the driver will have to
go look to see what's going on.  But I guess it doesn't really make
things worse either; I won't try to stand in its way.  It would be nice
to see a real changelog on the patch, though.

jon
