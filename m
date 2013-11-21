Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3KUVgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:36:07 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:52338 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3KUVgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:36:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131121.192051.747601347584525020.hdoyu@nvidia.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
	<20131121151218.befbb483c0cf09cdcd4cd4dd@nvidia.com>
	<20131121155649.48C96C406A3@trevor.secretlab.ca>
	<20131121.192051.747601347584525020.hdoyu@nvidia.com>
Date: Thu, 21 Nov 2013 15:36:03 -0600
Message-ID: <CAL_JsqK_TRjt9KigRA4yXcvEq0XriGxCy+50CY-BdJd62vHLCg@mail.gmail.com>
Subject: Re: [PATCHv5 1/9] of: introduce of_property_for_earch_phandle_with_args()
From: Rob Herring <robherring2@gmail.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:20 AM, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> Grant Likely <grant.likely@linaro.org> wrote @ Thu, 21 Nov 2013 16:56:49 +0100:
>
>> On Thu, 21 Nov 2013 15:12:18 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
>> > On Thu, 21 Nov 2013 13:43:28 +0100
>> > Grant Likely <grant.likely@linaro.org> wrote:
>> >
>> > > On Tue, 19 Nov 2013 11:33:05 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
>> > > > The following pattern of code is tempting:
>> > > >
>> > > >   for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)
>> > > >
>> > > > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>> > >
>> > > That's a very minimal commit message. Can you elaborate please.
>> >
>> > The above can be:
>> >
>> > "
>> >   The following pattern of code is tempting to add a new member for
>> >   of_property_for_each_*() family as an idiom.
>> >
>> >     for (i = 0;
>> >         !of_parse_phandle_with_args(np, list, cells, i, args); i++)
>> >                   <do something with "args">;
>> > "
>>
>> I really do like commit messages to be full enough that a future reader
>> can figure out why a patch was written. ie:
>
> Updated as:
>
>   [PATCHv6+ 01/13] of: introduce of_property_for_earch_phandle_with_args()

You also have a typo in the subject.

s/earch/each/

Rob
