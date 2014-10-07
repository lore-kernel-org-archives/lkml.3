Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaJGH4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:56:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:24008 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJGH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:56:37 -0400
Message-ID: <54339CB2.9010202@atmel.com>
Date: Tue, 7 Oct 2014 09:56:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Masahiro Yamada" <yamada.m@jp.panasonic.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: linux-next: manual merge of the kbuild tree with the arm-soc
 tree
References: <20141007123926.0e14810b@canb.auug.org.au>
In-Reply-To: <20141007123926.0e14810b@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 03:39, Stephen Rothwell :
> Hi Michal,
> 
> Today's linux-next merge of the kbuild tree got a conflict in
> arch/arm/mach-at91/Makefile between commit 91a55d4f6900 ("ARM: at91:
> introduce OLD_IRQ_AT91 Kconfig option") from the arm-soc tree and
> commit ac84eb47cc19 ("kbuild: remove unnecessary variable
> initializaions") from the kbuild tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Fix is good. Thanks Stephen.

Bye,
-- 
Nicolas Ferre
