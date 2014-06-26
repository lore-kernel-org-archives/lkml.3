Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbaFZPAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:00:38 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4959 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaFZPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:00:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Jun 2014 07:50:41 -0700
Date: Thu, 26 Jun 2014 18:00:33 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: define and export __clk_get_debug for providers
Message-ID: <20140626150033.GH3679@tbergstrom-lnx.Nvidia.com>
References: <1403788921-7963-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1403788921-7963-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 03:22:01PM +0200, Peter De Schrijver wrote:
> Define and export a new function __clk_get_debug which returns the debugfs
> directory entry pointer. This can be used by clock providers to add debugfs
> entries which are not related to a specific clock type. Examples include the
> ability to measure the rate of a clock. It can also be used by modules to
> create new debugfs entries. This is useful if you want to expose features
> for testing which can potentially cause system instability such as allowing
> to change a clock's rate from userspace.

Oops. Ignore this :)

