Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3BYOzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:55:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab3BYOzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:55:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 01/11] ARM: disable virt_to_bus/virt_to_bus almost everywhere
Date: Mon, 25 Feb 2013 14:54:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-next@vger.kernel.org
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <20130222101359.0c91a7259f648a3d06221bd8@canb.auug.org.au> <512B72A7.6040307@synopsys.com>
In-Reply-To: <512B72A7.6040307@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302251454.47617.arnd@arndb.de>
X-Provags-ID: V02:K0:x/e7rwKl69Et33Lfhjyxpv+GTHbc3oPD2xaaqHFzj2d
 UYT9FfBoKtNu1oTDPq6r8GHcijU0WKWJhv3UVn1YjNiuFbKK/Z
 R2KCKGKkTOAOzwtWHaMnZV/4LQWvCfzw8tfI5/S666D/HwEAat
 BX5cg/2A4jVOgwKtqjSLey1BoPpmY2EOno9zK+h6K2/WWoS0ek
 K+RR8mj4QaNPpboDh0I5Im5rahNdJpyr/CE1l30xlHkcUXeXC8
 9EPvQCWbNKVs/ZaAigY5ZC3vdyUrnuYUyXR/epJClzZ5188JEF
 1+YMxekLS1bHn7g7oTAAWr3KyNE+SQc7S3UoSuPEGHlYdsdbmk
 Z2Lzf2etod8FfO+kjmYI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2013, Vineet Gupta wrote:
> Have you queued up this change via one of your trees already for 3.9-rcX ?
> If not, I can fold it in with a bunch of Kconfig cleanups for ARC
> (GENERIC_SIGALTSTACK, HAVE_IRQ_WORK), given that those bits are already in linus'
> tree.
> 

I haven't put it in my tree yet, not. Please put it in yours.

	Arnd
