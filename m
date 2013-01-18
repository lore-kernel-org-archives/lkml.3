Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3ARTrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:47:23 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39793 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3ARTrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:47:22 -0500
Date: Fri, 18 Jan 2013 11:47:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: [PATCH] platform: Fix platform device resource linking
Message-ID: <20130118194717.GB18658@kroah.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com>
 <20130103224020.GB4571@kroah.com>
 <CD23CDD8-5740-4649-8876-ADDFCFF30C35@antoniou-consulting.com>
 <20130117163159.GD1396@kroah.com>
 <95056678-DF1A-4C49-BEAE-C5EBD7E56405@antoniou-consulting.com>
 <20130117170719.GB9163@kroah.com>
 <87DCB3B7-0A5A-42F0-BF9C-0E91B56960C6@antoniou-consulting.com>
 <20130118030017.GA11423@kroah.com>
 <82FE4A4D-DCA8-4C2C-97E7-6B73D424DCF5@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82FE4A4D-DCA8-4C2C-97E7-6B73D424DCF5@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:05:14AM +0200, Pantelis Antoniou wrote:
> It might make sense for the of_device_* functions that are duplicating 
> platform_device_* functions to be removed, and their functionality to 
> be subsumed by platform_device_*, possibly by calling some helper functions
> in drivers/of/ when of_node is not NULL. The of_device_* functions can be 
> replaced by a direct call to platform_device_* via a define (until all of
> the callers get converted).

That sounds reasonable.

> The problem with doing anything like this would be that a whole bunch of
> devices/arches depend on DT, and if anything breaks there will be a lot of
> angry people with pitchforks after the culprit.

That's nothing new, we are totally used to that happening :)

> So without the full force of a core maintainer behind such a move, people
> are reluctant to do so.   

Send patches if you want to do this, no need for the maintainer to do it
(hint, I will not as I don't even have a system that this type of code
runs on.)

thanks,

greg k-h
