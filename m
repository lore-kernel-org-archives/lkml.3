Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaHGInK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:43:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:31590 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbaHGInH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:43:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,816,1400050800"; 
   d="scan'208";a="572990566"
Date: Thu, 7 Aug 2014 11:43:02 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>, Darren Hart <dvhart@linux.intel.com>
Cc: Andrea Adami <andrea.adami@gmail.com>, chiau.ee.chew@intel.com,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Russell King <linux@arm.linux.org.uk>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] spi/pxa2xx-pci: Add common clock framework support in
 PCI glue layer
Message-ID: <20140807084302.GO1657@lahna.fi.intel.com>
References: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
 <20140725053230.GT1857@lahna.fi.intel.com>
 <CAAQYJAtM79NJJtfNYda-yFk113nm-2D8gZE5x=gbnLt2_eUdzQ@mail.gmail.com>
 <20140729185529.GG17528@sirena.org.uk>
 <CAAQYJAtLVgqbs=n2gxyemDAoHhM=7PFJy9bqKUExTbC+1rSNMg@mail.gmail.com>
 <D004FADD.9F315%dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D004FADD.9F315%dvhart@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 08:55:50AM -0700, Darren Hart wrote:
> On 7/29/14, 15:06, "Andrea Adami" <andrea.adami@gmail.com> wrote:
> 
> >On Tue, Jul 29, 2014 at 8:55 PM, Mark Brown <broonie@kernel.org> wrote:
> >> On Tue, Jul 29, 2014 at 06:13:06PM +0200, Andrea Adami wrote:
> >>
> >>> note that a previous version of the patch breaks spi on pxa machines:
> >>> tested on pxa250 poodle and pxa255 corgi.
> >>> The patch is included in linux-Yocto since 3.14.
> >>
> >> The interesting question is if this version works...
> >
> >Happy to report that I could finally test on poodle/pxa250 the current
> >v2 and the patch doesn't seem to disturb the probe.
> >Sorry for the noise.
> >
> >Andrea
> >
> 
> I tested this (v2) on the MinnowBoard-Max (Baytrail Atom E3825) in PCI
> mode and successfully attached an MCP32XX ADC and tested it's IIO
> interface.

Mark,

Any idea what happened to this patch? I didn't find it in linux-next and
it looks like it is not merged with mainline either.
