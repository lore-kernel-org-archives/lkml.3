Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3BPNRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 08:17:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3BPNRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 08:17:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 3/3] ARM: mm: use static_vm for managing static mapped areas
Date: Sat, 16 Feb 2013 13:17:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>, js1304@gmail.com,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
References: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com> <201302161249.08597.arnd@arndb.de> <20130216125205.GO17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130216125205.GO17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302161317.21541.arnd@arndb.de>
X-Provags-ID: V02:K0:BCv/tLirK+XpRBNAF7e7YXBitSQn7I5BJrCCxbZ8TM9
 voeASWt/aJPokQRbnqATUr7n+qWkI5jMIS3IHNInPSDkwrVyUC
 aTmLrZbzmcguMkGQXqwH2rgZVAEQKAUwkFKPCUXg43Z2HvVcIA
 cyNG1N5BJJdKt52kCRK88sFpRrtVbAulE91ESdClmnqPWDAxvf
 3NWHRvQnenf+O6k7yyz1KjMV6nHhKvi5LYdTORDBfe6BdaWPsw
 J3MyUuuAqSPYIK31cATwDAvLAargY8K34YrjETQaB8lC71e8cC
 s9i9u/ZFLrkngPnoh81UqwX6P+JrLDYKdfJAV6rgRE4C45AU/o
 eQbbB9LH+f9EKyUxMUv4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2013, Russell King - ARM Linux wrote:
> I already have such a patch in my tree - may not have pushed it out
> as I've been ill (and am still recovering.)

Ok, thanks for the quick confirmation!

Get well soon,

	Arnd
