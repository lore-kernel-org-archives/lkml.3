Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaCZRgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:36:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50639 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaCZRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:36:46 -0400
Date: Wed, 26 Mar 2014 17:36:03 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Tejun Heo <tj@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix Marvell SATA driver dependencies
Message-ID: <20140326173603.50e50e34@alan.etchedpixels.co.uk>
In-Reply-To: <4852939.9jMb8Bv2x2@amdc1032>
References: <5138028.BSQbEP7RRB@amdc1032>
	<20140326162302.GG25349@lunn.ch>
	<20140326165904.70de238d@alan.etchedpixels.co.uk>
	<4852939.9jMb8Bv2x2@amdc1032>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> shows up it is not enough to enable driver for it to make it work as
> you also need to add a node describing your SATA MV variant to your SoC
> device tree file (which requires updating kernel source anyway).

You still have to recompile your kernel to update your device tree..
how... quaint ;-). It's not a generic limitation but I'm not that fussed.
It seems a fair argument that there would be other changes made when this
was being done for a system, and probably new board stuff.

Alan
