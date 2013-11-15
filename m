Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3KOPE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:04:58 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64744 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3KOPEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:04:30 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: Strange location and name for platform  devices when device-tree is used.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1383338001.28909.42.camel@pasglop>
References: <20131101145925.66e22f73@notabene.brown> <1383279744.28909.26. camel@pasglop> <1383280054.28909.30.camel@pasglop> <20131101160329.37f3707b @notabene.brown> <1383282516.28909.36.camel@pasglop> <20131101180459. 81793C40A28@trevor.secretlab.ca> <1383338001.28909.42.camel@pasglop>
Date: Fri, 15 Nov 2013 16:37:25 +0900
Message-Id: <20131115073725.83C11C407FE@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Nov 2013 07:33:21 +1100, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Fri, 2013-11-01 at 11:04 -0700, Grant Likely wrote:
> 
> > There are two problems here. First, making the change moves all the DT
> > populated devices under the /sys/devices/platform tree, not just
> > platform devices.
> 
> All DT populated *platform* devices. There are others that have their
> own locations.

They are all in the same tree! Move the platform devices and everything
else moves to because they are under them.

g.
