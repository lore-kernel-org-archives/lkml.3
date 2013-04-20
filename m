Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3DTXqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 19:46:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3DTXqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 19:46:20 -0400
Date: Sun, 21 Apr 2013 01:46:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 0/3] rtc: rtc-hid-sensor-time
In-Reply-To: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
Message-ID: <alpine.LNX.2.00.1304210144050.11076@pobox.suse.cz>
References: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013, Alexander Holler wrote:

> as I'm not sure if the maintainer of the RTC subsystem is active again,
> I've added the people which where involved with rtc-hid-sensor-time
> before to cc too. That might be a good idea even he is active again,
> as the driver depends on hid-sensor-hub and as such works a bit
> outside the stuff other RTC drivers do use.

Agreed. I'd say let's wait if RTC maintainer(s) step up and have anything 
to say to this patchset.

If there's a silence, it'll probably be ok taking it through my review 
process and my tree, but at least for 3/3 I'd definitely like to have Ack 
from someone else as well.

For this reason, this is likely not be 3.10 material, but 3.11.

Thanks,

-- 
Jiri Kosina
SUSE Labs
