Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3LSQfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:35:18 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:57531 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3LSQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:35:15 -0500
X-Hashcash: 1:20:131219:akpm@linux-foundation.org::RLRzfAAmijtEkos0:0000000000000000000000000000000000002rjf
X-Hashcash: 1:20:131219:sfr@canb.auug.org.au::vOT1Aj3qvBGAPZ69:000000000000000000000000000000000000000009iPJ
X-Hashcash: 1:20:131219:jason@lakedaemon.net::4sv7zNJqTpWMKt8H:0000000000000000000000000000000000000000029yH
X-Hashcash: 1:20:131219:linux-kernel@vger.kernel.org::ppfF2gEk3z9PTRa2:0000000000000000000000000000000003JXV
X-Hashcash: 1:20:131219:mark.rutland@arm.com::RzqHn5wCIsWeXwmd:0000000000000000000000000000000000000000015iZ
X-Hashcash: 1:20:131219:a.zummo@towertech.it::g50pvzGLanAIau2T:0000000000000000000000000000000000000000024Bb
X-Hashcash: 1:20:131219:peter.huewe@infineon.com::zfxBTaDeyaGpLM3r:00000000000000000000000000000000000000d3d
X-Hashcash: 1:20:131219:linus.walleij@linaro.org::oJB6+eDX2S4AjpTH:00000000000000000000000000000000000000zz1
X-Hashcash: 1:20:131219:treding@nvidia.com::/I00a5r9nxjdkPdR:00000000000000000000000000000000000000000001Dyg
X-Hashcash: 1:20:131219:broonie@kernel.org::8cWPc9jMXhv4+Wc8:00000000000000000000000000000000000000000000LoF
X-Hashcash: 1:20:131219:rob.herring@calxeda.com::CkopfK4t7At3PDt7:000000000000000000000000000000000000004RH9
X-Hashcash: 1:20:131219:pawel.moll@arm.com::9VVaPs5govTe/Gwg:00000000000000000000000000000000000000000005wdA
X-Hashcash: 1:20:131219:swarren@wwwdotorg.org::ooZUYX0AJKLrmzq1:00000000000000000000000000000000000000002uPR
X-Hashcash: 1:20:131219:ijc+devicetree@hellion.org.uk::nNkqBGDt46i7lthQ:000000000000000000000000000000006HVK
X-Hashcash: 1:20:131219:grant.likely@linaro.org::63A/odNye0unciv4:0000000000000000000000000000000000000016Iv
X-Hashcash: 1:20:131219:rob@landley.net::Jol1VwL2KTo2u+F+:007TEo
X-Hashcash: 1:20:131219:rtc-linux@googlegroups.com::Za9XZftn0boq81WT:000000000000000000000000000000000005JGS
X-Hashcash: 1:20:131219:linux@roeck-us.net::UF5uEuUhn3yaMkZu:0000000000000000000000000000000000000000000EVEa
X-Hashcash: 1:20:131219:jgunthorpe@obsidianresearch.com::kix5DXk7YO56Ap8h:0000000000000000000000000000001QUs
X-Hashcash: 1:20:131219:galak@codeaurora.org::7jD72o31Kc5/cOLp:000000000000000000000000000000000000000003caN
X-Hashcash: 1:20:131219:linux-arm-kernel@lists.infradead.org::gbt28Z/CGuIwVKmS:00000000000000000000000004KEe
From: arno@natisbad.org (Arnaud Ebalard)
To: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Peter Huewe <peter.huewe@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Guenter Roeck <linux@roeck-us.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Can someone Ack and queue a patch for RTC subsytem?
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
Date: Thu, 19 Dec 2013 17:34:09 +0100
Message-ID: <87siton6ke.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a very simple driver (support for reading and setting the time)
for a RTC chip (Intersil ISL 12057) but cannot find anyone to get it
Acked and queued for v3.14. In v3.14, there should be at least three
users of the driver (ReadyNAS 102, 104 and 2120) if I meet -rc5 cutoff
for associated .dts changes.

I never heard of *listed* RTC maintainer during all the review process
on rtc-linux list (v0 sent in october); I dug the list archives and when
this previously happened, someone else (e.g. Andrew Morton) was kind
enough to handle the patches:

  http://www.spinics.net/lists/arm-kernel/msg292187.html

I wonder if someone (Andrew? Stephen? Jason?) would be kind enough to
take care of the v6 I just sent [1].

It has been:

  Reviewed-by: Guenter Roeck <linux@roeck-us.net>
  Reviewed-by: Mark Brown <brownie@linaro.org>

Cheers,

a+

[1]: http://patchwork.ozlabs.org/patch/303616/
