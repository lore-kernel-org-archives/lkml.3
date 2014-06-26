Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaFZVg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:36:58 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54633 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaFZVg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:36:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
User-Agent: alot/0.3.5
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1401462237-14954-1-git-send-email-pdeschrijver@nvidia.com>
 <20140613080239.GO5961@tbergstrom-lnx.Nvidia.com>
 <20140626163906.GI3679@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140626163906.GI3679@tbergstrom-lnx.Nvidia.com>
Message-ID: <20140626213645.32686.26036@quantum>
Subject: Re: [PATCH RESEND] clk: flatten clk tree in debugfs
Date: Thu, 26 Jun 2014 14:36:45 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2014-06-26 09:39:06)
> On Fri, Jun 13, 2014 at 10:02:39AM +0200, Peter De Schrijver wrote:
> > On Fri, May 30, 2014 at 05:03:57PM +0200, Peter De Schrijver wrote:
> > > This patch flattens the clk tree in CCF debugfs. Instead of representing the
> > > clocks and their hierarchy as a directory structure under
> > > /sys/kernel/debug/clk, each clock gets a single directory directly under
> > > /sys/kernel/debug/clk. The orphans directory is replaced by a file called
> > > clk_orphan_summary.
> > 
> > Mike,
> > 
> > Any problems with this? What needs to be done to make this patch go forward?

Applied to clk-next.

Regards,
Mike

> > 
> 
> Do you think this could be merged for the 3.17?
> 
> Thanks,
> 
> Peter.
