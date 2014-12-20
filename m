Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaLTHcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 02:32:01 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51011 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLTHb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 02:31:59 -0500
Date: Fri, 19 Dec 2014 23:31:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, Dudley Du <dudl@cypress.com>,
        rydberg@euromail.se, bleung@google.com, dso@cypress.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Message-ID: <20141220073154.GB4637@dtor-ws>
References: <1418896856-15766-1-git-send-email-dudl@cypress.com>
 <20141220071533.GA1139@newt.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141220071533.GA1139@newt.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 11:15:33PM -0800, Jeremiah Mahler wrote:
> Dudley,
> 
> On Thu, Dec 18, 2014 at 06:00:44PM +0800, Dudley Du wrote:
> > V16 patches have below updates, details of other updates see history list:
> [...]
> 
> This version has problems.  I am getting an oops (below) and then things
> quit working and usually my machine hangs.
> 
> [    2.388284] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
> [    2.412938] FS-Cache: Netfs 'nfs' registered for caching
> [    2.427645] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
> [    2.428320] __add_probed_i2c_device failed to register device 1-4a
> [    2.428331] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
> [    2.429126] fbcon: inteldrmfb (fb0) is primary device
> [    2.449066] BUG: unable to handle kernel NULL pointer dereference at 0000000000000160
> [    2.449073] IP: [<ffffffff813f7b2b>] input_mt_sync_frame+0xb/0x60

Sounds like we got an interrupts before we had a chance to initialize
input device...

Thanks.

-- 
Dmitry
