Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaCGQ2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:28:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63135 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaCGQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:28:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] asm-generic: rwsem: de-PPCify rwsem.h
Date: Fri, 7 Mar 2014 17:27:55 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1394204724-18898-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1394204724-18898-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403071727.56263.arnd@arndb.de>
X-Provags-ID: V02:K0:kXYpR5UjKK3zsZHo2/tTCCAYDYOQBc1KH/j8oRmuXLX
 9ja7HsuT/YE8caFDc/bD37YsXEjCLeAaNCrFiOFjxFvh+NqOM/
 lbqRyFyrYtu6YeEz9oCQr2FOjynU4kEf5kgr6ROwKG1bhwqMTH
 toZSMPWISsTQCC1yB5BskZF8isYXHqw5GQMeUh+RbJMZDTFm2Z
 zJxQvVKQ+Y8CAlRNzhOh3QByjIkBRF2LC8Vfk8ehrcbJ0CRR2z
 9U5/Ge6DMRAtnM9aNqnt/QwNVOG6POB/w4U2X4YgHHlk1W7e6o
 p/y1+xuBi7m03V9YmabxjOM2TEbZpzV2Yz7j782wphrvEPTB0z
 Nt42LkwsBmSvO8dnra2M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014, Will Deacon wrote:
> asm-generic/rwsem.h used to live under arch/powerpc. During its
> liberation to common code, a few references to its former home where
> preserved, in particular the definition of RWSEM_ACTIVE_MASK is
> predicated on CONFIG_PPC64.
> 
> This patch updates the ifdefs and comments to architecturally neutral
> versions.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Richard Kuo <rkuo@codeaurora.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
> 
> Hi Arnd,
> 
> Any chance you could queue this for 3.15 please? It means I can easily
> move arm64 over to the asm-generic rwsem implementation afterwards.
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

I don't expect any conflicts, so just put it in the arm64 tree along with
the patch to use it.

	Arnd
