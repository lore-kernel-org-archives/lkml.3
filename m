Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3H0IzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:55:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:35666 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3H0IzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:55:06 -0400
Message-ID: <521C6961.9020103@linutronix.de>
Date: Tue, 27 Aug 2013 10:54:57 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au>
In-Reply-To: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 10:13 AM, Stephen Rothwell wrote:

> Today's linux-next merge of the arm-soc tree got a conflict in 
> arch/arm/boot/dts/am335x-bone.dts between commit 97238b35d5bb
> ("usb: musb: dsps: use proper child nodes") from the  tree and
> commit 63f6b2550aa0 ("ARM: dts: AM33XX: don't redefine OCP bus and
> device nodes") from the arm-soc tree.
> 
> I fixed it up (probably incorrectly - see below) and can carry the
> fix as necessary (no action is required).

You added the OCP node back and the USB nodes as I had them which
should be fine.

How do we solve the conflict for the merge window? Is it possible for
the ARM-SOC tree to create a topic branch for this commit?

Greg: I do have a pending pull / patches [0] which also change the dts
nodes according to the latest feedback + enabling an additional USB
port in bone.
If you take this in I could update the nodes later (with the topic
branch merged) accordingly to the way it has been done in the ARM-SOC
tree - unless you have other preferences.

[0] http://www.spinics.net/lists/linux-usb/msg92595.html

Sebastian
