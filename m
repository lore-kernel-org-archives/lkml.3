Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3FJSDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:03:18 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53272 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3FJSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:03:15 -0400
Date: Mon, 10 Jun 2013 11:03:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>
Subject: Re: [PATCH V3 1/2] tps6507x-ts: Add DT support
Message-ID: <20130610180311.GA4649@core.coreip.homeip.net>
References: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
 <1369126458-24872-2-git-send-email-manishv.b@ti.com>
 <20130610060442.GA30158@core.coreip.homeip.net>
 <A4887BF146CD57468F700B415D2F47015A0DFD@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A4887BF146CD57468F700B415D2F47015A0DFD@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manish,

On Mon, Jun 10, 2013 at 10:23:16AM +0000, Vishwanathrao Badarkhe, Manish wrote:
> Hi Dmitry,
> 
> On Mon, Jun 10, 2013 at 11:34:42, Dmitry Torokhov wrote:
> > Hi Manish,
> > 
> > On Tue, May 21, 2013 at 02:24:17PM +0530, Vishwanathrao Badarkhe, Manish wrote:
> > 
> > > +	struct touchscreen_init_data *init_data = NULL;
> > > +	int err;
> > > +
> > > +	if (node)
> > > +		node = of_find_node_by_name(node, "tsc");
> > 
> > Why do you have to locate OF node manually instead of already having it attached to the device stucture?
> 
> As TPS6507x is mfd device containing two nodes, regulator and touchscreen.
> It is necessary to use "of_find_node_by_name" to find child "tsc" node of 
> TPS6507x MFD device.

I understand that TPS6507x is a MFD device, However, I still do not
understand why you do not attach OF data to the child platform device
representing touchscreen when you create it.

Thanks.

-- 
Dmitry
