Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab3FMKFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:05:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758325Ab3FMKFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:05:17 -0400
Date: Thu, 13 Jun 2013 12:05:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Dillow <dave@thedillows.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: fold ps3remote driver into generic Sony driver
In-Reply-To: <1371090818.28385.0.camel@obelisk.thedillows.org>
Message-ID: <alpine.LNX.2.00.1306131205010.6750@pobox.suse.cz>
References: <alpine.LNX.2.00.1305281035370.3914@pobox.suse.cz>  <1369747847.3675.3.camel@obelisk.thedillows.org>  <alpine.LNX.2.00.1305281538360.3914@pobox.suse.cz>  <1370062502.2606.5.camel@obelisk.thedillows.org>
 <1371090818.28385.0.camel@obelisk.thedillows.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, David Dillow wrote:

> > I tried to test this tonight, but was thwarted by Fedora 16 on the only
> > readily available test platform -- old bluetoothd w/ the internal
> > driver. I'll need to upgrade that box, recreate the updated bluetooth
> > environment I had from some time ago, or try it on my myth frontend
> > (Ubuntu 13.04). I'll get another chance on the 9th; I won't have access
> > to the HW again until then. :/
> 
> Ok, finally wrestled Myth away from family long enough to test. All
> looks good, sorry about the delay.
> 
> Tested-by: David Dillow <dave@thedillows.org>

Perfect, thanks, queued for 3.11.

-- 
Jiri Kosina
SUSE Labs
