Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaF0Hbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:31:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6715 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0Hbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:31:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 27 Jun 2014 00:25:29 -0700
Date: Fri, 27 Jun 2014 10:31:40 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] clk: flatten clk tree in debugfs
Message-ID: <20140627073140.GK3679@tbergstrom-lnx.Nvidia.com>
References: <1401462237-14954-1-git-send-email-pdeschrijver@nvidia.com>
 <20140613080239.GO5961@tbergstrom-lnx.Nvidia.com>
 <20140626163906.GI3679@tbergstrom-lnx.Nvidia.com>
 <20140626213645.32686.26036@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140626213645.32686.26036@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 11:36:45PM +0200, Mike Turquette wrote:
> Quoting Peter De Schrijver (2014-06-26 09:39:06)
> > On Fri, Jun 13, 2014 at 10:02:39AM +0200, Peter De Schrijver wrote:
> > > On Fri, May 30, 2014 at 05:03:57PM +0200, Peter De Schrijver wrote:
> > > > This patch flattens the clk tree in CCF debugfs. Instead of representing the
> > > > clocks and their hierarchy as a directory structure under
> > > > /sys/kernel/debug/clk, each clock gets a single directory directly under
> > > > /sys/kernel/debug/clk. The orphans directory is replaced by a file called
> > > > clk_orphan_summary.
> > > 
> > > Mike,
> > > 
> > > Any problems with this? What needs to be done to make this patch go forward?
> 
> Applied to clk-next.
> 

Thanks!

Peter.
