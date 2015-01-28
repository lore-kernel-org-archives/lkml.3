Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbbA2BII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:08:08 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57534 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbbA2BID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:08:03 -0500
Date: Thu, 29 Jan 2015 00:41:45 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/8] ARM: Conexant Digicolor CX92755 SoC support
Message-ID: <20150128224145.GK3148@tarshish>
References: <cover.1420744368.git.baruch@tkos.co.il>
 <5966468.GiJYdzCvnt@wuerfel>
 <1422484395.3621.73.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422484395.3621.73.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Jan 28, 2015 at 11:33:15PM +0100, Paul Bolle wrote:
> On Thu, 2015-01-08 at 23:46 +0100, Arnd Bergmann wrote:
> > Once there are no more review comments, please submit the first three
> > patches to arm@kernel.org, and send the other patches as separate
> > series to the respective maintainers for irqchip and clocksource.
> 
> I found this message while looking into CONFIG_ARCH_DIGICOLOR. That
> Kconfig macro entered linux-next in next-20150128. But there's no
> Kconfig symbol ARCH_DIGICOLOR yet in linux-next.

Just for the record: base digicolor platform support is in the for-next branch 
of arm-soc.git since today. I guess it should appear in linux-next tomorrow.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
