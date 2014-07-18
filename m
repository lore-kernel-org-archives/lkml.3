Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330AbaGRVyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:54:10 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:65017 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaGRVyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:54:08 -0400
Date: Fri, 18 Jul 2014 17:54:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v5 1/8] of: Add NVIDIA Tegra SATA controller binding
Message-ID: <20140718215404.GA1819@htj.dyndns.org>
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com>
 <1405667500-7402-1-git-send-email-mperttunen@nvidia.com>
 <53C8C9BD.3070709@nvidia.com>
 <53C8F6E6.6020901@redhat.com>
 <20140718150603.GA7196@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718150603.GA7196@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:06:04PM +0200, Thierry Reding wrote:
> I think the following patches can go through your tree without causing
> breakage through unresolved dependencies:
> 
> 	[PATCH v5 1/8] of: Add NVIDIA Tegra SATA controller binding
> 	[PATCH v3 6/8] ata: ahci_platform: Increase AHCI_MAX_CLKS to 4
> 	[PATCH v5 7/8] ata: Add support for the Tegra124 SATA controller

Applied to libata/for-3.17 w/ Hans' acks added.  Please check the
following branch and give me a holler if something is amiss.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.17

Thanks.

-- 
tejun
