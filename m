Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaG2HOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:14:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44648 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbaG2HOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:14:52 -0400
Date: Tue, 29 Jul 2014 09:14:47 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 4/8] ata: libahci: allow to use multiple PHYs
Message-ID: <20140729071447.GA9410@kwain>
References: <1406193450-17283-1-git-send-email-antoine.tenart@free-electrons.com>
 <1406193450-17283-5-git-send-email-antoine.tenart@free-electrons.com>
 <53D62624.6070502@redhat.com>
 <20140728172724.GA7462@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140728172724.GA7462@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 28, 2014 at 01:27:24PM -0400, Tejun Heo wrote:
> On Mon, Jul 28, 2014 at 12:29:56PM +0200, Hans de Goede wrote:
> ...
> > > +		if (!enabled_ports) {
> > > +			dev_warn(dev, "No port enabled\n");
> > > +			return ERR_PTR(-ENODEV);
> > 
> > This should be:
> > 			rc = -ENODEV;
> > 			goto err_out;
> > 
> > Sorry for not catching that sooner.
> > 
> > Other then that the entire series looks good and is:
> > 
> > Acked-by: Hans de Goede <hdegoede@redhat.com>
> 
> Antoine, can you please post an updated version of this patch?  No
> need to repost the whole series.  Also, how should the series be
> routed?

Sure, I'm doing this right away. Regarding the series, Kishon already
took patches 1-2.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
