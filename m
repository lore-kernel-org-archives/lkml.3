Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaKAXAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:00:08 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11525 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaKAXAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:00:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/1yq/C3zm0Bfw6uiH8dofZ7wYpvG+5lns=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8BFBB60F023
Date: Sat, 1 Nov 2014 18:59:53 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Benoit Masson <benoitm@perenite.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
Message-ID: <20141101225953.GF3698@titan.lakedaemon.net>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <-7443282711873112734@unknownmsgid>
 <20141003141102.GJ3895@titan.lakedaemon.net>
 <542EBB93.108@gmail.com>
 <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com>
 <542EC3A3.1060605@gmail.com>
 <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com>
 <5432BFB1.2060300@gmail.com>
 <CE7A9795-C2AF-451A-8018-3A0B8788BF60@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CE7A9795-C2AF-451A-8018-3A0B8788BF60@perenite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 02:53:02AM +0200, Benoit Masson wrote:
> 
> Le 6 oct. 2014 à 18:13, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
> 
> > On 10/06/2014 01:11 AM, Benoit Masson wrote:
> >> Le 3 oct. 2014 à 17:41, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
> >>> On 10/03/2014 05:29 PM, Benoit Masson wrote:
> >>>> Le 3 oct. 2014 à 17:06, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
> >>>>> On 10/03/2014 04:11 PM, Jason Cooper wrote:
> >>>>>> On Sun, Sep 21, 2014 at 04:11:23PM +0200, Benoit Masson wrote:
> >>>>>>>> Le 19 sept. 2014 à 22:14, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
> >>> [...]
> >>>>>>>> Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
> >>>>>>>> a hurry. I only compile tested this, so a formal Tested-by from Benoit
> >>>>>>>> for the ix4 and any other Armada XP board would be great.
> >>>>>>> 
> >>>>>>> I'm not sure what to test since I only receive some patch from the
> >>>>>>> series of 8. Should I get all 8 or only those you sent me. I'll be
> >>>>>>> able to test during next week.
> >>>>>> 
> >>>>>> Did you ever get a chance to test this series?
> >>>>> 
> >>>>> Uhm, I never prepared a branch for Benoit to test. I have pushed the
> >>>>> patches with Thomas Acked-by's and renamed eeprom node based on
> >>>>> v3.17-rc1 to
> >>>>> 
> >>>>> https://github.com/shesselba/linux-dove.git devel/mvebu-ix4
> >>>>> 
> >>> [...]
> >> Maybe I missed something ? is this branch you sent me a bare fork
> >> from mainline 3.17 ? does it includes the armada XP step A0 patch ?
> > 
> > Benoit,
> > 
> Hi,
> > I prepared more branches with the series
> > - on top of v3.17 release:
> > https://github.com/shesselba/linux-dove.git devel/mvebu-ix4_v3.17
> > 
> > - on top of next-20141003 (i.e. what will become v3.18-rc1):
> > https://github.com/shesselba/linux-dove.git devel/mvebu-ix4_next-20141003
> > 
> > It would be great, if you can test in this order:
> > - vanilla v3.17
> > - mvebu-ix4_v3.17
> > - mvebu-ix4_next-20141003
> > 
> All the 3 branch works WHEN APPLYING A0 patch (below), with both my
> custom kernel config and the arch/arm/configs/mvebu_v7_defconfig

Can I count this as a Tested-by?

> The reason why it didn't worked last time was that apparently the A0
> patch (copied) below was not merged into 3.17 :(

Yep, sorry.  Life got the best of me.  The pull request is now sent.

> This means that ix4-300d support is broken on 3.17 because of the A0
> stepping patch not merged.

Not a problem.  It's flagged for stable v3.12 and up.

thx,

Jason.
