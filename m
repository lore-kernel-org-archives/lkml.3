Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaDWI6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:58:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55380 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752333AbaDWI6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:58:05 -0400
Date: Wed, 23 Apr 2014 10:58:02 +0200
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
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] ARM: berlin: add the AHCI node for the BG2
Message-ID: <20140423085802.GF24355@kwain>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
 <1398181105-19714-6-git-send-email-antoine.tenart@free-electrons.com>
 <20140423104539.37c9366f@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140423104539.37c9366f@xhacker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jisheng,

On Wed, Apr 23, 2014 at 10:45:39AM +0800, Jisheng Zhang wrote:
> On Tue, 22 Apr 2014 08:38:24 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> 
> > The BG2 has an AHCI SATA controller. Add the corresponding node
> > in its device tree.
> 
> The AHCI IP of BG2 is different with BG2Q, so the driver in the series of patch
> doesn't work on BG2.

Thanks for the info! I'll drop BG2 and BG2CD nodes in the v2.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
