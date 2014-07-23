Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbaGWUYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:24:07 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50338 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423AbaGWUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:24:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH RESEND v2] bus: ARM CCN PMU driver
Date: Wed, 23 Jul 2014 22:23:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
References: <1406050379-15199-1-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1406050379-15199-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407232223.39341.arnd@arndb.de>
X-Provags-ID: V02:K0:udWdDohILSM+w6KdFDuHheuQQxv39c8+uMjqnV7xPbC
 z2p8iMoZLUNZLqdnqAa0E8t0x6XiFmgr7d83P4V6hHsEO0NSX2
 LkKcTv6uLNuBSOmnk/aDOgD8WsT/rj1hHaWFucRyhQHqQSrjzt
 MCuiQ0K+rOvMMJOHVZ1F8VFMrUQRn2qX63Z+GM906hny9ncq38
 oOkIJeAC/udnOc3Xb90obULo1XPorMBb4RcoAknynpLoocmuRK
 7yRfN2aWxNSXFxQY3KE8JjGQxwisAIKHq6Qhr+PEUshL8PVrKK
 bHkg+WezGWzebuEgZ5S7FwvihgVtRj7zOHE0i63B9/DEBd5zdK
 NfXZuPc1ZPo+xRvsU57Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014, Pawel Moll wrote:
> Driver providing perf backend for ARM Cache Coherent Network
> interconnect. Supports counting all hardware events and crosspoint
> watchpoints.
> 
> Currently works with CCN-504 only, although there should be
> no changes required for CCN-508 (just impossible to test it now).
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Applied to next/drivers, thanks!

	Arnd
