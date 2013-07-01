Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3GAMva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:51:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3GAMv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:51:29 -0400
Date: Mon, 1 Jul 2013 14:51:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pinglinux@gmail.com
Subject: Re: [PATCH] hid: wacom: Intuos4 battery charging changes
In-Reply-To: <1372499833-7814-1-git-send-email-przemo@firszt.eu>
Message-ID: <alpine.LNX.2.00.1307011451120.29977@pobox.suse.cz>
References: <1372499833-7814-1-git-send-email-przemo@firszt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jun 2013, Przemo Firszt wrote:

> Intuos4 WL is separately reporting power supply and battery
> charging status - now hid-wacom is using that information.
> Previously hid-wacom was wrongly treating "battery charging" bit
> as "power supply connected". Now it should report battery charging,
> battery discharging, battery full and power supply status.
> 
> Intuos4 WL sends reports when is in use (obvious) and when unplugging
> power supply. If means that if the device is being charged, but it's not
> being used it will never report "battery full". The same problem happens
> after the device has been connected, but it's not in use - the
> battery/ac status will be incorrect. Currently there is no mechanism to
> ask the device to send a report containing battery/ac status.
> 
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>

Applied, thanks Przemo.

-- 
Jiri Kosina
SUSE Labs
