Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab3GLPcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:32:16 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57139 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029Ab3GLPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:32:15 -0400
X-Auth-Info: NK/ABMYt40EOGglJfITomAHN7cLbmKls2TmqjlAtqJw=
Date: Fri, 12 Jul 2013 17:32:05 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Alexander Popov <a13xp0p0v88@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, lars@metafoo.de
Subject: Re: [V2 1/2] powerpc: mpc512x_dma: add support for data transfers
 between memory and i/o memory
Message-ID: <20130712153205.GI2615@book.gsilab.sittig.org>
Mail-Followup-To: Alexander Popov <a13xp0p0v88@gmail.com>,
	Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	lars@metafoo.de
References: <1373451651-20029-1-git-send-email-a13xp0p0v88@gmail.com>
 <20130710125811.GB2615@book.gsilab.sittig.org>
 <CAF0T0X70wa1DBPtvccr+-cb9_2AAw1tFaqJSt7_7GP-xa1qyVg@mail.gmail.com>
 <20130712121441.GH2615@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712121441.GH2615@book.gsilab.sittig.org>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 14:14 +0200, Gerhard Sittig wrote:
> 
> We shall combine the parts which currently are floating around.
> So that others aren't supposed to pick up pieces but instead can
> use a series and get something consistent.
> 
> Here are the parts that I'm aware of:
> - Anatolij's work that was motivated by SD card support, the
>   mxcmmc(4) part went mainline, the DMA part did not (patchwork
>   2368581, 2368591)
> - Lars' work on OF support that was motivated by a different
>   platform but is useful for the MPC512x as well (2331091)
> - your Alex' work that is motivated by SCLPC support is currently
>   under review (while the DMA part appears to re-use Anatolij's
>   approach?)
> - my local work that's picking up Anatolij's previous work and
>   includes items which are unrelated to DMA yet are helpful here
>   (MPC512x common clock support, preprocessor use in DTS builds)
> 
> So I suggest that I create an RFC series which combines those
> parts that I consider "DMA related", which you can in turn put
> your SCLPC support onto, or pick it up and fold it into yours.
> The latter may be more appropriate since announcing something via
> OF is only useful after implementing the support (here: slave
> S/G in the DMA engine).

for the record: the series was just sent out

  From: Gerhard Sittig <gsi@denx.de>
  To: linuxppc-dev@lists.ozlabs.org,
	  devicetree-discuss@lists.ozlabs.org,
	  Alexander Popov <a13xp0p0v88@gmail.com>
  Cc: Dan Williams <djbw@fb.com>,
	  Vinod Koul <vinod.koul@intel.com>,
	  Lars-Peter Clausen <lars@metafoo.de>,
	  Arnd Bergmann <arnd@arndb.de>,
	  Anatolij Gustschin <agust@denx.de>,
	  Gerhard Sittig <gsi@denx.de>
  Subject: [PATCH RFC 0/8] MPC512x DMA slave s/g support, OF DMA lookup
  Date: Fri, 12 Jul 2013 17:26:13 +0200
  Message-Id: <1373642781-32631-1-git-send-email-gsi@denx.de>


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
