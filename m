Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3LCGrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 01:47:21 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10784 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3LCGrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 01:47:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Dec 2013 22:40:43 -0800
Date: Tue, 3 Dec 2013 08:46:50 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCHv6+++ 01/13] of: introduce
 of_property_for_earch_phandle_with_args()
Message-ID: <20131203084650.bf498e1eb6883e38d873ef4a@nvidia.com>
In-Reply-To: <CAL_JsqKDokswB1jJN7ZT-Us0h=uTf5qHLZFUJfGFkXBjdO5XjA@mail.gmail.com>
References: <20131128.145818.1345100874304396564.hdoyu@nvidia.com>
	<20131129.134625.431945240074254704.hdoyu@nvidia.com>
	<529B8739.60701@wwwdotorg.org>
	<20131202.130220.1404999403649937134.hdoyu@nvidia.com>
	<CAL_JsqKDokswB1jJN7ZT-Us0h=uTf5qHLZFUJfGFkXBjdO5XjA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013 15:39:25 +0100
Rob Herring <robherring2@gmail.com> wrote:

> On Mon, Dec 2, 2013 at 5:02 AM, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> > Stephen Warren <swarren@wwwdotorg.org> wrote @ Sun, 1 Dec 2013 20:00:09 +0100:
> >
> >> On 11/29/2013 04:46 AM, Hiroshi Doyu wrote:
> >> ...
> >> > Iterating over a property containing a list of phandles with arguments
> >> > is a common operation for device drivers. This patch adds a new
> >> > of_property_for_each_phandle_with_args() macro to make the iteration
> >> > simpler.
> >> >
> >> > Introduced a new struct "of_phandle_iter" to keep the state when
> >> > iterating over the list.
> >> >
> >> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
....

Rob, thank you for review.
I'll fix them and put this one into the next v7 series.
