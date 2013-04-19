Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968125Ab3DSLAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 07:00:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12161 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967914Ab3DSK77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:59:59 -0400
X-AuditID: cbfee68d-b7f786d000005188-da-517123adc0e4
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Alexander Shiyan'" <shc_work@mail.ru>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>
References: <20130410171743.2ffa67388b330991228a6775@canb.auug.org.au>
 <30ad01ce35c6$8b13cb10$a13b6130$%kim@samsung.com>
 <20130411083702.GE31465@quad.lixom.net>
In-reply-to: <20130411083702.GE31465@quad.lixom.net>
Subject: RE: linux-next: manual merge of the arm-soc tree with the pm tree
Date: Fri, 19 Apr 2013 19:59:57 +0900
Message-id: <064401ce3ced$07bd3840$1737a8c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac42j77Suh8UbVkRROW8jaIkehjJsAGXEqyg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zY921yoWBBrs3aFr8nXSM3WLT42us
	Fpd3zWGzOLiwjdHi1PXPbBb9C3uZLLbuvcpuMWmHlMXGrx4OnB6/f01i9Gi8cYPN4861PWwe
	m5fUe1w50cTqMWXuEVaPR4tbGD0+b5IL4IjisklJzcksSy3St0vgylj20azgAX/F9vUfmRoY
	N/J0MXJySAiYSHzsecMOYYtJXLi3nq2LkYtDSGAZo8TWAwuZYYrerp0FlVjEKPFu619mCOcv
	o8TUQ89YQarYBDQkDr9/BjZKREBV4smTLlaQImaBVUwSP17fZYLoWMIoMeXSVEaQKk6guevn
	NYJ1CAt4SezdMhGog4ODBaj7yidBkDCvgK3Et8ZuJghbUOLH5HssIDazgJbE+p3HmSBseYnN
	a94yg7RKCKhLPPqrC3GDkcTLA7eYIUpEJPa9eMcIcoKEQC+HxLopF8DmsAgISHybfIgFoldW
	YtMBqI8lJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtQrTswtLs1L10vO
	z93ECIn13h2Mtw9YH2JMBlo/kVlKNDkfmCrySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cCouOxTytt70qfWm4WLtSq25n3tWHeQXanbhmGl19qD
	yxadiHpWu/D0pud/XOeXvq28+WWqVdGU/bkbuxedy5jFbbi+6MFi83cnP/vqT3heleqq/cbQ
	fE269dKdCUdezhc9cEy8Rv/nkk+zN1bY37hz4qSccRe7xRuT606cet1r9Jue1b02/mr6Xoml
	OCPRUIu5qDgRAKrRBc4LAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAd21yoWBBv2nlS3+TjrGbrHp8TVW
	i8u75rBZHFzYxmhx6vpnNov+hb1MFlv3XmW3mLRDymLjVw8HTo/fvyYxejTeuMHmcefaHjaP
	zUvqPa6caGL1mDL3CKvHo8UtjB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsY8xY9tGs4AF/xfb1H5kaGDfydDFyckgImEi8XTuLDcIWk7hwbz2QzcUhJLCIUeLd
	1r/MEM5fRomph56xglSxCWhIHH7/jB3EFhFQlXjypIsVpIhZYBWTxI/Xd5kgOpYwSky5NJUR
	pIoTaMf6eY1gHcICXhJ7t0wE6uDgYAHqvvJJECTMK2Ar8a2xmwnCFpT4MfkeC4jNLKAlsX7n
	cSYIW15i85q3zCCtEgLqEo/+6kLcYCTx8sAtZogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsC
	RpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGJ5Jn0DsZVDRaHGAU4GJV4eBskCgKFWBPL
	iitzDzFKcDArifCKyxcGCvGmJFZWpRblxxeV5qQWH2JMBvpzIrOUaHI+MMnllcQbGpuYGVka
	mVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjfNP6o093qj9TzmvsNUtyuGEX
	uTNd5Mwy7vWzeVd5eLi+6J63qb3skOaL/k6O7gMcZ1rNHm66Lyqx09xjq8OxPZ/Fdy/f1Gze
	diR+xssI05CGFGuOnhlHDpvw5rF/vKxx+MCei4+vxGY9XS3DmSu1+6XEjccC617cvHKWUXQx
	+xrLb1ujeUX4lViKMxINtZiLihMBEKa+OGgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Wed, Apr 10, 2013 at 05:36:49PM +0900, Kukjin Kim wrote:
> > Stephen Rothwell wrote:
> > >
> > > Hi all,
> > >
> > Hi,
> >
> > > Today's linux-next merge of the arm-soc tree got a conflict in
> > > arch/arm/mach-s3c24xx/Kconfig between commit 785f40040874 ("cpufreq:
> > > s3c24xx: move cpufreq driver to drivers/cpufreq") from the pm tree and
> >
> > As I know, Rafael will drop it in his tree.
> > http://lists-archives.com/linux-kernel/27815851-cpufreq-s3c24xx-move-
> cpufreq
> > -driver-to-drivers-cpufreq.html
> >
> > > commits fb278af74b28 ("ARM: S3C24XX: Removed unneeded dependency on
> > > CPU_S3C2410") and a4e4d22c6f53 ("ARM: S3C24XX: Removed unneeded
> > > dependency on CPU_S3C2412") from the arm-soc tree.
> > >
> > > I fixed it up by removing the sections from arch/arm/mach-
> s3c24xx/Kconfig
> > > and can carry thefix as necessary (no action is required).
> > >
> > Thanks.
> >
> > > P.S. those arm-soc tree commits have a bad Author email address ...
> >
> > Oops :-( it's my fault due to e-mail client problem...
> >
> > Arnd, it happened in next/dt-exynos, next/mct-exynos and
> > next/cleanup-samsung branches in my tree.
> >
> > And I sorted out in my local just now. Could you please re-pull them
> into
> > arm-soc? Then, I will push forced. Sorry about that.
> 
> Given that it's "just" formatting errors, I would prefer not repulling and
> rebuilding just because of it. For someone reading the information it's

Hmm...if possible, I'm still hoping, you could replace previous branches
which including 'wrong format' for author e-mail :-) But up to you.

> pretty
> obvious what the valid email address would be. Please try to be mindful of
> it

OK.

> in the future though (and we'll try to double-check these things too).
> 
BTW, if you don't want to pull, I need to re-send for '[GIT PULL 4/4]
dt-exynos 2 for v3.10'...

But I'm not sure it's possible...

Anyway, sorry for noise.

- Kukjin

