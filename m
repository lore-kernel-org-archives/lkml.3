Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3BLH0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 02:26:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53986 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab3BLH0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 02:26:47 -0500
Message-ID: <5119EEB4.70508@ti.com>
Date: Tue, 12 Feb 2013 08:26:44 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH v2 09/11] mfd: twl-core: Collect global variables behind
 one private structure (global)
References: <1358344439-23017-1-git-send-email-peter.ujfalusi@ti.com> <1358344439-23017-10-git-send-email-peter.ujfalusi@ti.com> <51154A7A.2010709@ti.com> <5115E3B9.6090100@ti.com> <51195301.8000606@ti.com>
In-Reply-To: <51195301.8000606@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 09:22 PM, Jon Hunter wrote:
> Good point. I just noticed that none of my omap2+ board were booting and
> on omap3/4 I was the panic in the twl code. I can't say that I checked
> the panic on omap2, so may be that was another problem?

Do you have insights on the code path leading to a crash on OMAP3/4? I have
been running this code on several boards (BeagleBoard, Zoom2, PandaBoard,
Blaze) and have not seen a crash.
But the fix is valid.

-- 
Péter
