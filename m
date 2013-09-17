Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3IQVIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:08:51 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59615 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3IQVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:08:49 -0400
Message-ID: <5238C4D1.6060500@gmail.com>
Date: Tue, 17 Sep 2013 14:08:33 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: "memory" binding issues
References: <1379300274.4098.77.camel@pasglop> <1379371567.3721.46.camel@pasglop> <CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com> <1815499.tpfeUKmP6V@flatron> <20130917164307.GA31327@quad.lixom.net>
In-Reply-To: <20130917164307.GA31327@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/2013 9:43 AM, Olof Johansson wrote:
> On Tue, Sep 17, 2013 at 09:56:39AM +0200, Tomasz Figa wrote:
>> I'm afraid that I must disagree. For consistency I'd rather go with what 
>> Ben said. Please see ePAPR chapter 2.2.1.1, which clearly defines how 
>> nodes should be named.
> 
> 2.2.1.1 is there to point out that unit address _has_ to reflect reg.
> 
> 2.2.3 says that unit addresses can be omitted.

2.2.3 is talking about path names.

2.2.1.1 is talking about node names.

2.2.1.1 _does_ require the unit address in the node name, 2.2.3 does not
remove that requirement.

-Frank

> 
>> Having unit-address whenever the node has a reg property has the nice 
>> property of eliminating the need to rename any nodes when adding new one. 
>> (Consider the case that you have one subnode somewhere and you omit the 
>> unit-address and then you find out that you have to add another subnode 
>> with the same name, but another reg value.)
> 
> This motivation doesn't bother me at all -- it should be relatively rare.
> 
> 
> -Olof
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

