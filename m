Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaAORPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:15:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56679 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAORPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:15:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Carino <marc.ceeeee@gmail.com>, Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 5/7] ARM: brcmstb: add misc. DT bindings for brcm,brcmstb-*
Date: Wed, 15 Jan 2014 18:15:10 +0100
Message-ID: <12927046.KPmoBiUFty@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140115171155.GK25824@e106331-lin.cambridge.arm.com>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com> <1389743333-16741-6-git-send-email-marc.ceeeee@gmail.com> <20140115171155.GK25824@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:upj3I+Ct2+xipsCHC+vSNkYMv4tHLEBEgDq7CFxxDEa
 pqXZWc2QtepyPTXyMTKW1VOSbIiXGWQ7KwAMJMqK5hgT4J0FNK
 UEP7I3linnkI6axbZMDt6vizFA6AVn/5nIXQL9q8IXXCn2cd8d
 72+PvB0sm92g/7aaluATxD0Q2f1dYl1GkR0WZIMlXfx6TJvzT5
 gbFEBUR/e9LaYpk7CIRsOrjcCfwV9/Wa7QTg9jpmbbST2odKpV
 4Kl0m/12NOQXv7zrcwBMbGNI/RyPgenX5NC3g+fshZohGDZ+JI
 S9vVqwAbiDLZMyvogu4uZe0KN0NhCqBMJRkGeP1ZQ6AC0x+1Gh
 39v+9FhQwMyLhT32qfXs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014 17:11:55 Mark Rutland wrote:
> > +
> > +Further, a node with the following compatible string shall be defined:
> > +
> > +    - compatible: "brcm,brcmstb-gen-ctrl-v1"
> 
> It's probably better to say a brcmstb-gen-ctrl node (described below)
> should be present, or you'll have two places to update the compatible
> strings for each new variant...

See my other reply on this node. The previous patch version had a different
approach to these registers, and I suggested doing yet another one and
using syscon.

	Arnd
