Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaIDKFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:05:10 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:63771 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbaIDKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:05:08 -0400
Message-ID: <1409825105.5546.91.camel@x220>
Subject: Re: [PATCH 11/19] ARM: S5PV210: Remove support for board files
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Thu, 04 Sep 2014 12:05:05 +0200
In-Reply-To: <53C675E4.4020502@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-12-git-send-email-t.figa@samsung.com>
	 <1405505072.4408.17.camel@x220> <53C675E4.4020502@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 10:05:05.0962 (UTC) FILETIME=[B39B68A0:01CFC827]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 14:53 +0200, Tomasz Figa wrote:
> I believe that both sound card drivers for Goni and Aquilla could be
> replaced with simple cards in DT, so I'll send a follow-up patch for this.

References to MACH_GONI and MACH_AQUILA can still be seen in v3.17-rc3
and next-20140903. Note that as consequence SND_SOC_GONI_AQUILA_WM8994
can not be set anymore.

> Most likely the same is the case for SMDK boards, but they don't seem to
> have any active users (see cover letter for more details), which means
> that probably they could be simply dropped from
> sound/soc/samsung/Kconfig in another follow-up patch.

Ditto for MACH_SMDKC100, MACH_SMDKC110, and MACH_SMDKV210. Note that
here SND_SOC_SMDK_WM8580_PCM can not be set anymore.

(This is intended to be a gentile reminder. I hope it actually comes
across like that.)


Paul Bolle

