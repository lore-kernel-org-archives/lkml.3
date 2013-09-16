Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3IPXrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:47:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:60768 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab3IPXrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:47:39 -0400
Message-ID: <1379375239.3721.51.camel@pasglop>
Subject: Re: "memory" binding issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Sep 2013 09:47:19 +1000
In-Reply-To: <CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com>
References: <1379300274.4098.77.camel@pasglop>
	 <52372F2A.2050003@wwwdotorg.org> <1379371567.3721.46.camel@pasglop>
	 <CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 15:48 -0700, Olof Johansson wrote:
> > A node that has a "reg" property should have the corresponding unit
> > address.
> 
> No, absolutely _NOT_ a requirement. Unit address is only required if
> needed to disambiguate two properties with the same name.
> 
> If there are no ambiguities, then leaving off the unit address is much
> preferred.

I disagree :-)

Also this would be only true of our find_node_by_path was capable of
handling it, which it isn't. Thus you end up with generic code looking
for /memory and finding nothing ... 

Cheers,
Ben.


