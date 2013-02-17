Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3BQPrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:47:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3BQPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:47:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH 02/11] ARM: samsung: fix assembly syntax for new gas
Date: Sun, 17 Feb 2013 15:47:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        stable@vger.kernel.org, arm@kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <20130216232550.GQ17833@n2100.arm.linux.org.uk> <20768.63816.104018.377650@pilspetsen.it.uu.se>
In-Reply-To: <20768.63816.104018.377650@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302171547.11614.arnd@arndb.de>
X-Provags-ID: V02:K0:OrSc8q272kqxSFHpmAnxILUQIdTrE9VVlA4gG8JsVjJ
 WprNGfAukjQRNfao1qPex+TsHEK1hm6bY7n6kjnyyeaRrbmtX6
 GPTOYJ36yfuDQWAmAb8kPbxwsmr1Bz7/9UsUPSCCqYiWwgkzA3
 wqpJoYOOpOWO0d1gGITVS2WcclnflRfZ0YstRa8rpvBNI2VgPk
 KGCBS1tUWgAhwpJNa9NgG0vQXIT2YNrnQmA5ZJ/+wZxDKDAw/u
 6QSZIKPbUdKAwpA112cLcPsYxzr67YfPMUdzyn7hUdFEMkx/6T
 TCDmNRGs0PUOs611XRBSriHtQs3K9PTTA1R7nluGLcGr1fpEId
 1PeSjy830rXEJQEdoiIo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2013, Mikael Pettersson wrote:
> Russell King - ARM Linux writes:
>  > On Thu, Feb 14, 2013 at 02:49:18PM +0100, Arnd Bergmann wrote:
>  > > Recent assembler versions complain about extraneous
>  > > whitespace inside [] brackets. This fixes all of
>  > > these instances for the samsung platforms. We should
>  > > backport this to all kernels that might need to
>  > > be built with new binutils.
>  > 
>  > I hope that's also been reported as a bug to the binutils people.
> 
> See PR gas/14887, a post binutils-2.23.1 regression which seems
> to be fixed on trunk but not on 2.23 branch.

Ok, thanks for the info, I just came to the same conclusion a few minutes
before your reply.

Since I have some binutils people listening now, maybe someone can
comment on the issue I tried working around in
https://patchwork.kernel.org/patch/2013211/

	Arnd
