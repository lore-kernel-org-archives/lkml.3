Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3CSLmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:42:49 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:55591 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876Ab3CSLmq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:42:46 -0400
Subject: Re: [PATCH 3/6] OF: Export all DT proc update functions
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130316094556.7898E3E09B0@localhost>
Date: Tue, 19 Mar 2013 13:42:32 +0200
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B488B3A5-C455-4DD2-BBB9-8C02E0851D17@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <1357327870-13615-4-git-send-email-panto@antoniou-consulting.com> <20130316094556.7898E3E09B0@localhost>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

The 3rd patch is in preparation for some patches I have in WIP that would allow
drivers to set notifications for properties that are changed in runtime.

I think that since you have the all configuration taking place via DT and you
have a method to alter DT properties in run-time via /proc/device-tree, it's quite
straightforward to be able to alter runtime behavior via the same mechanism.

I.e. if you have some property that controls a devices behavior, it's intuitive that
when you modify that property, the device's state changes accordingly.

Regards

-- Pantelis

On Mar 16, 2013, at 11:45 AM, Grant Likely wrote:

> On Fri,  4 Jan 2013 21:31:07 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> There are other users for the proc DT functions.
>> Export them.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> Hi Pantelis.
> 
> Patches 1 & 2 look good. No comments there.
> 
> This patch bothers me. The manipulation of the proc entries is part and
> parcel of adding and removing nodes. The real problem seems to be that
> the node addition/removal APIs need to be made usable by the overlay
> code.
> 
> g.

