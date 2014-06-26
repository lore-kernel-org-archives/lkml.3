Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaFZKtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:49:16 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1344 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbaFZKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:49:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jun 2014 03:43:01 -0700
Date: Thu, 26 Jun 2014 13:49:09 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: define and export __clk_get_debug for providers
Message-ID: <20140626104909.GD3679@tbergstrom-lnx.Nvidia.com>
References: <1403713591-17179-1-git-send-email-pdeschrijver@nvidia.com>
 <44039675.8s16pHQIVH@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <44039675.8s16pHQIVH@wuerfel>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 08:07:37PM +0200, Arnd Bergmann wrote:
> On Wednesday 25 June 2014 19:26:31 Peter De Schrijver wrote:
> > Define and export a new function __clk_get_debug which returns the debugfs
> > directory entry pointer. This can be used by clock providers to add debugfs
> > entries which are not related to a specific clock type. Examples include the
> > ability to measure the rate of a clock. It can also be used by modules to
> > create new debugfs entries. This is useful if you want to expose features
> > for testing which can potentially cause system instability such as allowing
> > to change a clock's rate from userspace.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > 
> 
> Just an idea, but would it be better to add a pair of functions to add/remove
> debugfs files rather than exposing the dentry itself?
> 

Ok. Will do that.

Cheers,

Peter.
