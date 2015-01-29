Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbbA2ORR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:17:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbbA2ORP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:17:15 -0500
Date: Thu, 29 Jan 2015 15:17:11 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mmc: Add hardware dependencies for sdhci-pxav3 and
 sdhci-pxav2
Message-ID: <20150129151711.454100be@endymion.delvare>
In-Reply-To: <CAPDyKFqWa0uyZStNT1Wp21HpSqYpfJx3wU3TDJy25uMgG7qZaw@mail.gmail.com>
References: <20150126112328.318da5e7@endymion.delvare>
	<CAPDyKFo363x7NGEctNwHkpn-6HkAu15qu-ZFtt73mJcWZrce4g@mail.gmail.com>
	<1422369244.4499.187.camel@chaos.site>
	<CAPDyKFqWa0uyZStNT1Wp21HpSqYpfJx3wU3TDJy25uMgG7qZaw@mail.gmail.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Wed, 28 Jan 2015 15:04:24 +0100, Ulf Hansson wrote:
> On 27 January 2015 at 15:34, Jean Delvare <jdelvare@suse.de> wrote:
> > Hi Ulf,
> >
> > Le Tuesday 27 January 2015 à 15:06 +0100, Ulf Hansson a écrit :
> >> On 26 January 2015 at 11:23, Jean Delvare <jdelvare@suse.de> wrote:
> >> > I seem to understand that the sdhci-pxav3 and sdhci-pxav2 drivers are
> >> > only needed on the MMP architecture. So add a hardware dependency on
> >> > ARCH_MMP, so that other users don't get to build useless drivers.
> >>
> >> I would rather see the default option to be N.
> >> Thus those configurations that needs this driver will have to select it.
> >
> > This is a different question. The purpose of my patch is that people
> > configuring kernels for systems which just can't have these controllers,
> > are not asked about this driver at all. Changing the default to N would
> > not achieve that.
> 
> For those SOC that want these drivers, they should be able to select
> them from their defconfigs. So it will be an opt-in instead of opt-out
> policy, which I prefer. It also follows the other Kconfig options for
> mmc drivers.

As you wish. But that change would be a separate patch going on top of
mine, right? I'm not sure I understand what you expect from me at this
point, please clarify.

-- 
Jean Delvare
SUSE L3 Support
