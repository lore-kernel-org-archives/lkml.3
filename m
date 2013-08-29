Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3H2Gv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:51:57 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15962 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3H2Gv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:51:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Aug 2013 23:49:22 -0700
Message-ID: <521EEF90.8070907@nvidia.com>
Date: Thu, 29 Aug 2013 09:52:00 +0300
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] ARM: tegra: Add host1x, dc and hdmi to Tegra114 device
 tree
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com> <1377686459-16634-5-git-send-email-mperttunen@nvidia.com> <20130828122529.GB32254@ulmo> <521DEFFF.90507@nvidia.com> <20130828131815.GB604@ulmo>
In-Reply-To: <20130828131815.GB604@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.08.2013 16:18, Thierry Reding wrote:
> I think that's not all. I have local patches that also introduce a v2 of
> host1x, because the number of syncpoints is different. There may also be
> other differences, but Terje might be more qualified to answer that.

Tegra4 host1x has an extra channel(totals 9), which caused bitfields in
a couple of registers to shift. The registers are mainly used in the
debug code to dump the channel FIFO. Same number of sync points as
Tegra3, but 12 wait bases.

Other changes are minor and driver already deals with them, for example
32-bit versus 16-bit sync point value comparison.

Terje
