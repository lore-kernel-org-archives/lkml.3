Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaBJPar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:30:47 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55719 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831AbaBJPao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:30:44 -0500
Message-ID: <1392046242.3585.41.camel@x220>
Subject: Re: [PATCH 14/28] Remove MACH_SMDKC210
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@kernel.org>
Cc: Richard Weinberger <richard@nod.at>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 16:30:42 +0100
In-Reply-To: <20140210141255.GI1757@sirena.org.uk>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-15-git-send-email-richard@nod.at>
	 <20140210114154.GQ1757@sirena.org.uk> <1392039072.3585.15.camel@x220>
	 <20140210141255.GI1757@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2014 15:30:43.0092 (UTC) FILETIME=[0F8C5D40:01CF2675]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 14:12 +0000, Mark Brown wrote:
> On Mon, Feb 10, 2014 at 02:31:12PM +0100, Paul Bolle wrote:
> > If so, to be absolutely sure we start from the same point: do you agree
> > that the above line now effectively reads
> >     depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDKV210 || MACH_SMDKC110 || false || false)
> 
> > because there's neither a Kconfig symbol MACH_SMDKV310 nor a Kconfig
> > symbol MACH_SMDKC210?
> 
> Yes, that's correct.  Now, like I say think about what the symbol was
> there for in the first place.

So, next step: the Kconfig symbols MACH_SMDKV310 and MACH_SMDKC210 were
removed in commit 383ffda2fa ("ARM: EXYNOS: no more support non-DT for
EXYNOS SoCs"). That commit was part of v3.11. Correct?

Thanks for your patience.


Paul Bolle

