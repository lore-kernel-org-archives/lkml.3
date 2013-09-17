Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3IQQnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:43:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57593 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3IQQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:43:42 -0400
Date: Tue, 17 Sep 2013 09:43:07 -0700
From: Olof Johansson <olof@lixom.net>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: "memory" binding issues
Message-ID: <20130917164307.GA31327@quad.lixom.net>
References: <1379300274.4098.77.camel@pasglop>
 <1379371567.3721.46.camel@pasglop>
 <CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com>
 <1815499.tpfeUKmP6V@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1815499.tpfeUKmP6V@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 09:56:39AM +0200, Tomasz Figa wrote:
> I'm afraid that I must disagree. For consistency I'd rather go with what 
> Ben said. Please see ePAPR chapter 2.2.1.1, which clearly defines how 
> nodes should be named.

2.2.1.1 is there to point out that unit address _has_ to reflect reg.

2.2.3 says that unit addresses can be omitted.

> Having unit-address whenever the node has a reg property has the nice 
> property of eliminating the need to rename any nodes when adding new one. 
> (Consider the case that you have one subnode somewhere and you omit the 
> unit-address and then you find out that you have to add another subnode 
> with the same name, but another reg value.)

This motivation doesn't bother me at all -- it should be relatively rare.


-Olof
