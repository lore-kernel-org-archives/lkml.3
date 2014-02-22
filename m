Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaBVNl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 08:41:26 -0500
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:46330 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaBVNlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 08:41:25 -0500
Date: Sat, 22 Feb 2014 15:41:21 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: "Cui, Dexuan" <dexuan.cui@intel.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>,
        Lars Kurth <lars.kurth@xenproject.org>
Subject: Re: [Xen-devel] [Announcement] Updates to XenGT - a Mediated
 Graphics Passthrough Solution from Intel
Message-ID: <20140222134121.GP3200@reaktio.net>
References: <A25F549E4D43CD42B4C02DF47A19132311058FC7@SHSMSX103.ccr.corp.intel.com>
 <20140220183613.GJ3200@reaktio.net>
 <A25F549E4D43CD42B4C02DF47A1913231105A665@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A25F549E4D43CD42B4C02DF47A1913231105A665@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 02:22:11AM +0000, Cui, Dexuan wrote:
> Pasi Kärkkäinen wrote on 2014-02-21:
> > On Thu, Feb 20, 2014 at 07:59:04AM +0000, Cui, Dexuan wrote:
> >> Hi all,
> >> We're pleased to announce an update to XenGT since its first disclosure in
> >> last Sep.
> > 
> > Are you going to work on upstreaming this stuff? Xen 4.4 will be
> > released soon(ish), so the Xen 4.5 development window starts in the near
> > future and hopefully this stuff can be upstreamed then..
> Hi Pasi,
> We do plan to upstream but not give a timeframe so far.
> 

Ok. Would you like to post an article on the Xen blog about XenGT ?
I think that would be a good thing to do to get more visibility for this feature.


> > Also: Haswell ("4th generation Intel core CPU") is listed as a requirement in
> > the Setup Guide PDF..
> > will there be support for SNB/IVB GPUs aswell?
> There is no plan for SNB/IVB.
> 

Is that because of some hardware limitation on earlier GPU generations,
or just a matter of amount of work needed to support XenGT on earlier GPUs?

Thanks,

-- Pasi

