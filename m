Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3HUQU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:20:56 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41443 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3HUQUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:20:53 -0400
Date: Wed, 21 Aug 2013 09:20:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LDOC <linux-doc@vger.kernel.org>,
        device-tree <devicetree-discuss@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] tps6507x-ts: Add DT support
Message-ID: <20130821162049.GA28359@core.coreip.homeip.net>
References: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
 <1369126458-24872-2-git-send-email-manishv.b@ti.com>
 <CA+V-a8u1BEXMHHso80NdP4FX_au2mnUEtzqYyJXg_vA9JvSJbA@mail.gmail.com>
 <CAKDJKT45=BUcx5q8bHL=xzHQ0aAhE=cwGy4EK8MWRfpiKVzt0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKDJKT45=BUcx5q8bHL=xzHQ0aAhE=cwGy4EK8MWRfpiKVzt0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

On Tue, Aug 20, 2013 at 12:25:32PM +0530, Manish Badarkhe wrote:
> Hi Prabhakar,
> 
> On Tue, Aug 20, 2013 at 11:44 AM, Prabhakar Lad
> >
> > All the three above properties as per the documentation  above
> > are optional, but the code here makes them required property.
> > May be what you can do is if property is not defined make it as
> > zero as per documentation.
> 
> I already taken care of this as per Dmitry's comment but not yet
> posted patch series as
> there is discussion going on populating child node's properties.

Please post the series using find node properties (as they were). We can
discuss if MFD devices should be automatically attaching parents OF data
to child devices they are creating later.

Thanks.

-- 
Dmitry
