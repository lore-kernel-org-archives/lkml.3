Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3CUMg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:36:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:54326 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab3CUMg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:36:57 -0400
Message-ID: <1363869397.17680.24.camel@pasglop>
Subject: Re: [PATCH 2/2] of: remove /proc/device-tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 21 Mar 2013 13:36:37 +0100
In-Reply-To: <CACxGe6thdnQo6sPDccEGzUEkXFDGRD4aq_DJOop6Cincb94ODA@mail.gmail.com>
References: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
	 <1363791074-16415-3-git-send-email-grant.likely@secretlab.ca>
	 <1363791479.12701.9.camel@pasglop>
	 <CACxGe6u2wNbPQSOPRCRO0To5UC-b8rXYanv2xv26hk5oaozvPA@mail.gmail.com>
	 <1363839594.17680.19.camel@pasglop>
	 <CACxGe6sXcg51VhFujsjCsMzF80pdy_QhAposdmya4-C0eEcuUw@mail.gmail.com>
	 <1363851836.17680.20.camel@pasglop>
	 <CACxGe6thdnQo6sPDccEGzUEkXFDGRD4aq_DJOop6Cincb94ODA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 08:16 +0000, Grant Likely wrote:
> On Thu, Mar 21, 2013 at 7:43 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Thu, 2013-03-21 at 07:35 +0000, Grant Likely wrote:
> >> > Shouldn't we have the symlink just be a config option itself ?
> >> > Eventually distros might want get rid of it completely ..
> >>
> >> Why? It is the cheapest thing in the world and it means the ABI
> >> doesn't change at all.
> >
> > It's also gross and forces sysfs to remain in /sys which isn't a kernel
> > enforced policy afaik.
> 
> Documentation/sysfs-rules.txt, Line 30

Whatever... it's still gross :-)

Cheers,
Ben.


