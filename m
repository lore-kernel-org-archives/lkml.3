Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaGUJCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:02:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51343 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753031AbaGUJCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:02:17 -0400
Date: Mon, 21 Jul 2014 11:02:13 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 3/8] ata: libahci_platform: move port_map parameters
 into the AHCI structure
Message-ID: <20140721090213.GC32208@kwain>
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405686607-8126-4-git-send-email-antoine.tenart@free-electrons.com>
 <20140718134730.GA13012@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140718134730.GA13012@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 18, 2014 at 09:47:30AM -0400, Tejun Heo wrote:
> On Fri, Jul 18, 2014 at 02:30:02PM +0200, Antoine Ténart wrote:
> > @@ -321,6 +321,8 @@ struct ahci_host_priv {
> >  	u32			cap;		/* cap to use */
> >  	u32			cap2;		/* cap2 to use */
> >  	u32			port_map;	/* port map to use */
> > +	u32			force_port_map;	/* force port map */
> > +	u32			mask_port_map;	/* mask out particular bits */
> 
> So, ->flags and ->force/mask_port_map are the only input ones, right?
> Can we collect them to one spot and label them as such?

Yes. So you want a comment about this in the header?

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
