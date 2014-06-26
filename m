Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaFZQjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:39:13 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9620 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbaFZQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:39:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Jun 2014 09:29:14 -0700
Date: Thu, 26 Jun 2014 19:39:06 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] clk: flatten clk tree in debugfs
Message-ID: <20140626163906.GI3679@tbergstrom-lnx.Nvidia.com>
References: <1401462237-14954-1-git-send-email-pdeschrijver@nvidia.com>
 <20140613080239.GO5961@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140613080239.GO5961@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:02:39AM +0200, Peter De Schrijver wrote:
> On Fri, May 30, 2014 at 05:03:57PM +0200, Peter De Schrijver wrote:
> > This patch flattens the clk tree in CCF debugfs. Instead of representing the
> > clocks and their hierarchy as a directory structure under
> > /sys/kernel/debug/clk, each clock gets a single directory directly under
> > /sys/kernel/debug/clk. The orphans directory is replaced by a file called
> > clk_orphan_summary.
> 
> Mike,
> 
> Any problems with this? What needs to be done to make this patch go forward?
> 

Do you think this could be merged for the 3.17?

Thanks,

Peter.
