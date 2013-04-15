Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3DOPNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:13:37 -0400
Received: from ra.se.axis.com ([195.60.68.13]:58602 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3DOPNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:13:36 -0400
Date: Mon, 15 Apr 2013 17:11:32 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jesper Nilsson <jespern@axis.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] cris: drop unused Kconfig symbols
Message-ID: <20130415151132.GJ11974@axis.com>
References: <1318595467.6132.80.camel@x61.thuisdomein>
 <20111014133354.GE9412@axis.com>
 <14215.1318619461@turing-police.cc.vt.edu>
 <20111031105959.GA26898@axis.com>
 <1364044486.1390.237.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364044486.1390.237.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 02:14:46PM +0100, Paul Bolle wrote:
> Jesper,
> 
> On Mon, 2011-10-31 at 11:59 +0100, Jesper Nilsson wrote:
> > Ok, let's do it the right way and remove them now, and I can re-add
> > them in the same tree.
> 
> The patch at the start of this (old) thread still applies on top of
> v3.9-rc3. Do you still intend to remove the cris Kconfig symbols unused
> in mainline?
> 
> (Note that there's a second order effect to this patch:
> ETRAX_ETHERNET_IFACE0, and ETRAX_ETHERNET_IFACE1, and ETRAX_SERIAL_PORT4
> could also be dropped. I'm happy to submit a patch with those included
> too.)

Yes, please do, I just get mangled versions when I try to dig
the old patch out from the web.

> Paul Bolle

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
