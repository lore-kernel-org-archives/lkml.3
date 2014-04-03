Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaDCUyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:54:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbaDCUyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:54:33 -0400
Date: Thu, 3 Apr 2014 22:54:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Chandler Paul <thatslyude@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [PATCH] Add sensor hub quirk for ThinkPad Helix
In-Reply-To: <1396556875-31108-1-git-send-email-thatslyude@gmail.com>
Message-ID: <alpine.LNX.2.00.1404032254210.32122@pobox.suse.cz>
References: <1396556875-31108-1-git-send-email-thatslyude@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014, Stephen Chandler Paul wrote:

> Just like some of the other laptops/tablets on the market with ultrabook
> sensors, the ThinkPad Helix's sensor hub requires a special quirk in
> order for it to power on properly. Without it the sensors are detected
> by the kernel and set up as usual, but they won't output any data. This
> will also fix the sensors on any other laptops with the same model of
> sensor hub.
> 
> Signed-off-by: Stephen Chandler Paul <thatslyude@gmail.com>

Queued for 3.15, thanks.

-- 
Jiri Kosina
SUSE Labs
