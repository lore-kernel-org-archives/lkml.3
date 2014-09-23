Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaIWJwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:52:21 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:38806 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbaIWJwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:52:18 -0400
Date: Tue, 23 Sep 2014 10:51:18 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Angus Gibson <angus@agibson.me>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [RFC PATCH linux-next] et131x: Promote staging et131x driver to
 drivers/net
Message-ID: <20140923095118.GC5130@leicester.auvation.com>
References: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
 <20140922235653.GA17359@angus-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922235653.GA17359@angus-mbp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:56:53AM +1000, Angus Gibson wrote:
> > +config NET_VENDOR_AGERE
> > +	bool "Agere devices"
> > +	default y
> > +	depends on PCI
> > +	---help---
> > +	  If you have a network (Ethernet) card belonging to this class, say =
> > Y
> > +	  and read the Ethernet-HOWTO, available from
> > +	  <http://www.tldp.org/docs.html#howto>.
> > +
> > +	  Note that the answer to this question doesn't directly affect the
> > +	  kernel: saying N will just cause the configurator to skip all
> > +	  the questions about Atheros devices. If you say Y, you will be aske=
> should this be "Agere devices" instead?

Yes it should - well spotted, thanks - I'll change this in v2.

Mark
