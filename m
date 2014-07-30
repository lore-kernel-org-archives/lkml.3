Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaG3HiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:38:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53232 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755061AbaG3HiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:38:21 -0400
Date: Wed, 30 Jul 2014 09:38:16 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 4/8] ata: libahci: allow to use multiple PHYs
Message-ID: <20140730073816.GA29900@kwain>
References: <1406618447-25499-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140729143438.GB4791@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140729143438.GB4791@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:34:38AM -0400, Tejun Heo wrote:
> On Tue, Jul 29, 2014 at 09:20:47AM +0200, Antoine Ténart wrote:
> > The current implementation of the libahci does not allow to use multiple
> > PHYs. This patch adds the support of multiple PHYs by the libahci while
> > keeping the old bindings valid for device tree compatibility.
> > 
> > This introduce a new way of defining SATA ports in the device tree, with
> > one port per sub-node. This as the advantage of allowing a per port
> > configuration. Because some ports may be accessible but disabled in the
> > device tree, the port_map mask is computed automatically when using
> > this.
> > 
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> > Acked-by: Hans de Goede <hdegoede@redhat.com>
> 
> Patch doesn't apply to libata/for-3.17.  Please refresh.

This patch is base on top of v3.16-rc7, taking in account a patch[1]
introduced after rc1 modifying this same file.

[1] https://lkml.org/lkml/2014/6/6/75

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
