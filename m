Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3KUBqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:46:05 -0500
Received: from host171.canaca.com ([67.55.55.225]:41643 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab3KUBqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:46:00 -0500
Message-ID: <9cdedd5704e7ac70a3f414512f2ee126.squirrel@mungewell.org>
In-Reply-To: <1384983141-31019-2-git-send-email-benjamin.tissoires@redhat.com>
References: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
    <1384983141-31019-2-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 20 Nov 2013 20:45:53 -0500
Subject: Re: [PATCH 1/3] Only process ABS_MT_SLOT where there are slots
 available
From: simon@mungewell.org
To: "Benjamin Tissoires" <benjamin.tissoires@redhat.com>
Cc: "Benjamin Tissoires" <benjamin.tissoires@gmail.com>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Herrmann" <dh.herrmann@gmail.com>,
        "Henrik Rydberg" <rydberg@euromail.se>,
        "Antonio Ospite" <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

> From: Antonio Ospite <ospite@studenti.unina.it>
>
> This fixes the case when a non-multitouch device happens to have a HID
> code equal to ABS_MT_SLOT, like the Sony Sixaxis has for the left dpad
> analog control.
>
> Updated to latest tree by Benjamin Tissoires.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Wow, its been a great week for the DualShock - got rumble and LED control,
and now I can confirm that the 'left D pad' analogue axis works.

Thanks guys,
Simon

tested-by: Simon Wood <simon@mungewell.org>

