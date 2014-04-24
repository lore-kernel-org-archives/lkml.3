Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaDXKi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:38:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36721 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753036AbaDXKiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:38:25 -0400
Date: Thu, 24 Apr 2014 12:26:39 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] ata: ahci: add AHCI support for Berlin SoCs
Message-ID: <20140424102639.GA31101@kwain>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
 <1398181105-19714-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140424175041.0bade2d6@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140424175041.0bade2d6@xhacker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On Thu, Apr 24, 2014 at 05:50:41PM +0800, Jisheng Zhang wrote:
> Hi Antoine,
> 
> On Tue, 22 Apr 2014 08:38:20 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> 
> > +		/* CT timing fix */
> > +		ahci_berlin_reg_set(ctrl_reg + PORT_VSR_ADDR, BIT(6) |
> > BIT(1));
> > +		ahci_berlin_reg_set(ctrl_reg + PORT_VSR_ADDR,
> > +				    BIT(15) | BIT(13) | BIT(12) | BIT(11) |
> > +				    BIT(10) | BIT(2) | BIT(1));
> 
> Could you please remove these code? They are not used for BG2Q, I'm sorry there's
> such mistake in the code I provided to you ;)

OK, thanks for the update!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
