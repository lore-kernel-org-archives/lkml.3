Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030751Ab3HITBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:01:18 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47345 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030715Ab3HITBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:01:17 -0400
Date: Fri, 9 Aug 2013 11:56:41 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add power_supply notifier
Message-ID: <20130809185640.GC979@lizard.mcd26095.sjc.wayport.net>
References: <1374780069-23670-1-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374780069-23670-1-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 12:51:09AM +0530, Jenny TC wrote:
> This patch adds a notifier chain to the power_supply.
> This notifier helps drivers in other subsystem to listen to
> changes in power supply subsystem. This would help to take some
> actions in those drivers on changing the power supply properties.
> One such scenario is to increase/decrease system performance based
> on the battery capacity/voltage. Another scenario is to adjust the
> h/w peak current detection voltage/current thresholds based on battery
> voltage/capacity. The notifier helps drivers to listen to changes
> in power_suppy susbystem without polling the power_supply properties
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---

Hi Jenny,

Can you please submit users of this new API as well, so that we could see
the whole picture?

Thanks,

Anton
