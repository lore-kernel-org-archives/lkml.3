Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab3LDKBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:01:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41179 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048Ab3LDKBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:01:52 -0500
Date: Wed, 4 Dec 2013 10:01:36 +0000
From: Will Deacon <will.deacon@arm.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alex.williamson@redhat.com
Subject: Re: [PATCHv6 05/13] iommu/core: add ops->{bound,unbind}_driver()
Message-ID: <20131204100136.GA10293@mudshark.cambridge.arm.com>
References: <1385041249-7705-1-git-send-email-hdoyu@nvidia.com>
 <1385041249-7705-6-git-send-email-hdoyu@nvidia.com>
 <20131125154937.d6dbe9aedc16aab335d92f99@nvidia.com>
 <20131204094027.dad1288aec14551ec42f3743@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204094027.dad1288aec14551ec42f3743@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiroshi,

On Wed, Dec 04, 2013 at 07:40:27AM +0000, Hiroshi Doyu wrote:
> On Mon, 25 Nov 2013 14:49:37 +0100
> Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> 
> > Hi Joerg,
> > 
> > Do you have some time to review this patch along with the following ones?
> > 
> >   [PATCHv6 02/13] iommu/of: introduce a global iommu device list
> >   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007050.html
> > 
> >   [PATCHv6 03/13] iommu/of: check if dependee iommu is ready or not
> >   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007051.html
> 
> Any chance to get some feedback on them?

Joerg is on holiday at the moment, but Alex Williamson is serving as interim
IOMMU maintainer at the moment. Adding him to CC, but this probably needs an
Ack from Joerg regardless, so you will need to wait for him to come back.

Will
