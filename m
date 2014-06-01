Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaFARLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 13:11:35 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59388 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaFARLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 13:11:34 -0400
X-Auth-Info: HOsKi/u8FepazxO3KNhQKHNjINfZ1jw88iUx+V3dIH8=
From: Marek Vasut <marex@denx.de>
To: Himangi Saraogi <himangi774@gmail.com>
Subject: Re: [PATCH] crypto: caam: Introduce the use of the managed version of kzalloc
Date: Sun, 1 Jun 2014 18:56:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.12.4; x86_64; ; )
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
References: <20140527182548.GA6333@himangi-Dell>
In-Reply-To: <20140527182548.GA6333@himangi-Dell>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201406011856.41778.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 27, 2014 at 08:25:48 PM, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions.  Also, linux/device.h is added to make sure the devm_*()
> routine declarations are unambiguously available. Earlier, in the probe
> function ctrlpriv was leaked on the failure of ctrl = of_iomap(nprop, 0);
> as well as on the failure of ctrlpriv->jrpdev = kzalloc(...); . These
> two bugs have been fixed by the patch.
> 
> The following Coccinelle semantic patch was used for making the change:

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
