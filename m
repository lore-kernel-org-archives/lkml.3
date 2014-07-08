Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaGHIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:16:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15723 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaGHIQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:16:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Jul 2014 01:09:56 -0700
Date: Tue, 8 Jul 2014 11:16:47 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: "abrestic@chromium.org" <abrestic@chromium.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Use XUSB-compatible SATA PLL sequence
Message-ID: <20140708081647.GV3679@tbergstrom-lnx.Nvidia.com>
References: <CAL1qeaHo_HEoXoCQjQuqux_BNPtz4BtOnrYTa4=vcNQCYxiDSg@mail.gmail.com>
 <1404804615-23587-1-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1404804615-23587-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 09:30:15AM +0200, Mikko Perttunen wrote:
> Use a sequence for enabling hardware control of the SATA PLL
> that works both when using the SATA lane with SATA and when
> using it with XUSB.
> 

I'm going to take it as a separate patch on top of what's there now.

Cheers,

Peter.
