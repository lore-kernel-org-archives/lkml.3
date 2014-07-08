Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaGHNmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:42:10 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:38829 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaGHNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:42:07 -0400
Date: Tue, 8 Jul 2014 09:42:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 3/7] ata: libahci: allow to use multiple PHYs
Message-ID: <20140708134203.GD4979@htj.dyndns.org>
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404728173-20263-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404728173-20263-4-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more thing.

On Mon, Jul 07, 2014 at 12:16:09PM +0200, Antoine Ténart wrote:
> This introduce a new way of defining SATA ports in the device tree, with
> one port per sub-node. This as the advantage of allowing a per port
> configuration. Because some ports may be accessible but disabled in the
> device tree, the default port_map is computed automatically when using
> this.

Any chance the old one phy config can be moved over to this scheme so
that we don't have to carry two separate mechanisms?

Thanks.

-- 
tejun
