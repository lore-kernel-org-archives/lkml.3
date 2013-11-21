Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3KURU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:20:57 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14484 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab3KURUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:20:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Nov 2013 09:14:52 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "grant.likely@linaro.org" <grant.likely@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Nov 2013 18:20:51 +0100
Subject: Re: [PATCHv5 1/9] of: introduce
 of_property_for_earch_phandle_with_args()
Thread-Topic: [PATCHv5 1/9] of: introduce
 of_property_for_earch_phandle_with_args()
Thread-Index: Ac7m3gd6oBWYFtrzRdSJxmXRaLMZQA==
Message-ID: <20131121.192051.747601347584525020.hdoyu@nvidia.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com><20131121151218.befbb483c0cf09cdcd4cd4dd@nvidia.com><20131121155649.48C96C406A3@trevor.secretlab.ca>
In-Reply-To: <20131121155649.48C96C406A3@trevor.secretlab.ca>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@linaro.org> wrote @ Thu, 21 Nov 2013 16:56:49 +0100:

> On Thu, 21 Nov 2013 15:12:18 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> > On Thu, 21 Nov 2013 13:43:28 +0100
> > Grant Likely <grant.likely@linaro.org> wrote:
> > 
> > > On Tue, 19 Nov 2013 11:33:05 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> > > > The following pattern of code is tempting:
> > > > 
> > > >   for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)
> > > > 
> > > > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > > 
> > > That's a very minimal commit message. Can you elaborate please.
> > 
> > The above can be:
> > 
> > "
> >   The following pattern of code is tempting to add a new member for
> >   of_property_for_each_*() family as an idiom.
> >   
> >     for (i = 0;
> >         !of_parse_phandle_with_args(np, list, cells, i, args); i++)
> >                   <do something with "args">;
> > "
> 
> I really do like commit messages to be full enough that a future reader
> can figure out why a patch was written. ie:

Updated as:

  [PATCHv6+ 01/13] of: introduce of_property_for_earch_phandle_with_args()
    http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007063.html

This doesn't depend on anything and this can be merged
independetly. Thanks for your help.
