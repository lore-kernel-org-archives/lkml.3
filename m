Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3BPL1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 06:27:12 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45336 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3BPL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 06:27:10 -0500
Date: Sat, 16 Feb 2013 12:27:14 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.8.0-rc7, nouveau, possible recursive locking,
 nouveau_instobj_create_ and nv50_disp_data_ctor
Message-ID: <20130216112714.GA3071@joi.lan>
References: <d4a52379a6aaf48bb47a6927e9a0de75@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4a52379a6aaf48bb47a6927e9a0de75@visp.net.lb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 12:57:07AM +0200, Denys Fedoryshchenko wrote:
> Hi
> 
> Booted on Toshiba laptop, x86_64, NVIDIA Corporation GT218 [GeForce 
> 310M], latest rc, and got this.
> Please let me know if you need additional information.

It's harmless and already quieted down in Linus' tree (post 3.8-rc7).
(Commit 5f97ab913cf0fbc378ea8ffc3ee66f4890d11c55)

Marcin
