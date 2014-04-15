Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaDOMuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:50:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbaDOMuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:50:15 -0400
Date: Tue, 15 Apr 2014 14:50:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
cc: linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH 0/4] HID: (thingm) introduces blink(1) mk2
In-Reply-To: <1397508620-15244-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Message-ID: <alpine.LNX.2.00.1404151450050.32344@pobox.suse.cz>
References: <1397508620-15244-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014, Vivien Didelot wrote:

> This patchset introduces the support of the blink(1) mk2 device, after a
> refactoring of the thingm driver. It removes non-standard sysfs attributes and
> uses work queues to fix the usage of triggers with this device.

Queued for 3.16. Thanks,

-- 
Jiri Kosina
SUSE Labs
