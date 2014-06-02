Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaFBD2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 23:28:36 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64010 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaFBD2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 23:28:35 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140602104957.21878870@canb.auug.org.au>
References: <20140602104957.21878870@canb.auug.org.au>
Date: Sun, 1 Jun 2014 20:28:34 -0700
Message-ID: <CAOesGMhDqYKSvxTK9pDnvWbmEUK_WUFKxGLJemZO6uFxtROcLg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2014 at 5:49 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-exynos/exynos.c between commits dfbdd3d55403 ("ARM: l2c:
> exynos: remove cache size override"), 25a9ef63cd2b ("ARM: l2c: exynos:
> convert to common l2c310 early resume functionality") and 15b0bc4041ba
> ("ARM: l2c: exynos: convert to generic l2c OF initialisation (and
> thereby fix it)") from the arm tree and commit b5b9324a6296 ("ARM:
> exynos: don't run exynos4 l2x0 setup on other platforms") from the
> arm-soc tree.
>
> I fixed it up (the former removes the code updated by the latter) and
> can carry the fix as necessary (no action is required).

Looks good. Thanks.


-Olof
