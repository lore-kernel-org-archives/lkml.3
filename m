Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3AUTCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:02:40 -0500
Received: from host171.canaca.com ([67.55.55.225]:44882 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab3AUTCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:02:37 -0500
X-Greylist: delayed 1354 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 14:02:37 EST
Message-ID: <d76e4c014234c2f0e8ef1328f0e7572a.squirrel@mungewell.org>
In-Reply-To: <1358792314-24596-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1358792314-24596-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Date: Mon, 21 Jan 2013 13:40:01 -0500
Subject: Re: [PATCH v2] HID: add ThingM blink(1) USB RGB LED support
From: simon@mungewell.org
To: "Vivien Didelot" <vivien.didelot@savoirfairelinux.com>
Cc: linux-input@vger.kernel.org,
        "Vivien Didelot" <vivien.didelot@savoirfairelinux.com>,
        "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +++ b/Documentation/ABI/testing/sysfs-driver-hid-blink1
> @@ -0,0 +1,23 @@
> +What:		/sys/class/leds/blink(1)::<serial>/rgb
> +Date:		January 2013
> +Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> +Description:	The ThingM blink(1) is an USB RGB LED. The color notation is
> +		3-byte hexadecimal. Read this attribute to get the last set
> +		color. Write the 24-bit hexadecimal color to change the current
> +		LED color. The default color is full white (0xFFFFFF).
> +		For instance, set the color to green with: echo 00FF00 > rgb
> +

Shouldn't the name presented in the sys/class/leds directories change
appropriately too?

Simon

