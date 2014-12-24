Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaLXGFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:05:32 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42177 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaLXGFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:05:31 -0500
Date: Wed, 24 Dec 2014 08:05:26 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] ARM: digicolor: add low level debug support
Message-ID: <20141224060525.GH2481@sapphire.tkos.co.il>
References: <cover.1419318109.git.baruch@tkos.co.il>
 <d161e426125c28c9698fa5fecad4e5278abc0895.1419318109.git.baruch@tkos.co.il>
 <2866303.axqKJidzX4@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2866303.axqKJidzX4@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Dec 23, 2014 at 10:00:17PM +0100, Arnd Bergmann wrote:
> On Tuesday 23 December 2014 09:58:39 Baruch Siach wrote:
> > @@ -14,5 +14,6 @@ static const char *digicolor_dt_compat[] __initconst = {
> >  };
> >  
> >  DT_MACHINE_START(DIGICOLOR, "Conexant Digicolor (Flattened Device Tree)")
> > +       .map_io         = debug_ll_io_init,
> >         .dt_compat      = digicolor_dt_compat,
> >  MACHINE_END
> 
> This change is not needed, the debug_ll_io_init function is used by default
> if no other map_io callback is specified.

OK. I'll remove it for next version.

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
