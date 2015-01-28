Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbbA2BPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:15:20 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61362 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbbA2BPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:15:11 -0500
Message-ID: <1422485520.3621.81.camel@x220>
Subject: Re: [PATCH v2 0/8] ARM: Conexant Digicolor CX92755 SoC support
From: Paul Bolle <pebolle@tiscali.nl>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Wed, 28 Jan 2015 23:52:00 +0100
In-Reply-To: <20150128224145.GK3148@tarshish>
References: <cover.1420744368.git.baruch@tkos.co.il>
	 <5966468.GiJYdzCvnt@wuerfel> <1422484395.3621.73.camel@x220>
	 <20150128224145.GK3148@tarshish>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2015 22:52:00.0446 (UTC) FILETIME=[06AFF5E0:01D03B4D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Baruch,

On Thu, 2015-01-29 at 00:41 +0200, Baruch Siach wrote:
> On Wed, Jan 28, 2015 at 11:33:15PM +0100, Paul Bolle wrote:
> > On Thu, 2015-01-08 at 23:46 +0100, Arnd Bergmann wrote:
> > > Once there are no more review comments, please submit the first three
> > > patches to arm@kernel.org, and send the other patches as separate
> > > series to the respective maintainers for irqchip and clocksource.
> > 
> > I found this message while looking into CONFIG_ARCH_DIGICOLOR. That
> > Kconfig macro entered linux-next in next-20150128. But there's no
> > Kconfig symbol ARCH_DIGICOLOR yet in linux-next.
> 
> Just for the record: base digicolor platform support is in the for-next branch 
> of arm-soc.git since today. I guess it should appear in linux-next tomorrow.

So I choose a less convincing patch series to discuss this. But that
doesn't alter the general issue I raised. At least, I hope it doesn't.

Thanks!


Paul Bolle

