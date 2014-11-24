Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaKXQQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:16:52 -0500
Received: from 8bytes.org ([81.169.241.247]:39723 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbaKXQQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:16:51 -0500
Date: Mon, 24 Nov 2014 17:16:48 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Thierry Reding <treding@nvidia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olav Haugan <ohaugan@codeaurora.org>
Subject: Re: linux-next: manual merge of the iommu tree with the tegra tree
Message-ID: <20141124161648.GI3762@8bytes.org>
References: <20141124153310.61fc2202@canb.auug.org.au>
 <20141124093237.GC19045@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124093237.GC19045@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, Nov 24, 2014 at 10:32:38AM +0100, Thierry Reding wrote:
> This conflict is uglier than I had anticipated. Perhaps it would make
> sense to pull in a stable IOMMU branch into Tegra so that I can resolve
> the conflict on top of that?
> 
> Joerg, do you have a stable branch containing the above commits that you
> could provide for me to pull into the Tegra tree?

Yes, you can pull in the core branch from the iommu-tree. It should
contain the conflicting patch.


	Joerg

