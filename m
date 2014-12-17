Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaLQQZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:25:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaLQQZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:25:19 -0500
Date: Wed, 17 Dec 2014 17:25:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Nicoletti <dantti12@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Allow HID_BATTERY_STRENGTH to be enabled
In-Reply-To: <1418824434-12947-1-git-send-email-dantti12@gmail.com>
Message-ID: <alpine.LNX.2.00.1412171724520.1680@pobox.suse.cz>
References: <1418824434-12947-1-git-send-email-dantti12@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Daniel Nicoletti wrote:

> Allows for HID_BATTERY_STRENGTH config be enabled without the need for 
> HID module to be built-in, prior to this HID and POWER_SUPPLY had to be 
> equal, and now we only select POWER_SUPPLY and depend on the HID module.
> 
> Signed-off-by: Daniel Nicoletti <dantti12@gmail.com>

Sorry for this taking too long. Now applied, thanks.

-- 
Jiri Kosina
SUSE Labs
