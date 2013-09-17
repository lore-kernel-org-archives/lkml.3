Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3IQVPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:15:55 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56454 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3IQVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:15:53 -0400
MIME-Version: 1.0
X-Originating-IP: [208.54.5.211]
In-Reply-To: <5238C4D1.6060500@gmail.com>
References: <1379300274.4098.77.camel@pasglop>
	<1379371567.3721.46.camel@pasglop>
	<CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com>
	<1815499.tpfeUKmP6V@flatron>
	<20130917164307.GA31327@quad.lixom.net>
	<5238C4D1.6060500@gmail.com>
Date: Tue, 17 Sep 2013 14:15:52 -0700
Message-ID: <CAOesGMh0F09OAR4bepGSCE5Z5OZ56fBmDPBSfwZ+NB9RgcE0Vw@mail.gmail.com>
Subject: Re: "memory" binding issues
From: Olof Johansson <olof@lixom.net>
To: frowand.list@gmail.com
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 2:08 PM, Frank Rowand <frowand.list@gmail.com> wrote:
> On 9/17/2013 9:43 AM, Olof Johansson wrote:
>> On Tue, Sep 17, 2013 at 09:56:39AM +0200, Tomasz Figa wrote:
>>> I'm afraid that I must disagree. For consistency I'd rather go with what
>>> Ben said. Please see ePAPR chapter 2.2.1.1, which clearly defines how
>>> nodes should be named.
>>
>> 2.2.1.1 is there to point out that unit address _has_ to reflect reg.
>>
>> 2.2.3 says that unit addresses can be omitted.
>
> 2.2.3 is talking about path names.
>
> 2.2.1.1 is talking about node names.
>
> 2.2.1.1 _does_ require the unit address in the node name, 2.2.3 does not
> remove that requirement.

Sigh, that's horrible. OF clearly doesn't require it.

I guess people prefer to follow ePAPR even though it's broken? That
means someone needs to cleanup the current dts files. Any takers?


-Olof
