Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaAXUOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:14:47 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56359 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbaAXUOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:14:46 -0500
Message-ID: <1390594484.15637.2.camel@x220>
Subject: Re: [PATCH] ALSA: hda - Fix silent output on MacBook Air 1,1
From: Paul Bolle <pebolle@tiscali.nl>
To: Adrien =?ISO-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "Nicolo'" <nicolopiazzalunga@gmail.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, Hui Wang <hui.wang@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Jan 2014 21:14:44 +0100
In-Reply-To: <1390593374-6592-1-git-send-email-adrienverge@gmail.com>
References: <1390593374-6592-1-git-send-email-adrienverge@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jan 2014 20:14:44.0496 (UTC) FILETIME=[EBFE8100:01CF1940]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 14:56 -0500, Adrien Vergé wrote:
> Similarly to other Apple products, MBA 1,1 needs a specific quirk.
> Pin 0x18 must be set to VREF_50 to have sound output.  This was no
> longer done since commit 1a97b7f, resulting in a mute built-in speaker.

Commit 1a97b7f ("ALSA: hda/realtek - Remove the last static quirks for
ALC882") was included in v3.4. Did no-one notice this for 9 releases?

> This patch corrects the regression by creating a fixup for the MBA 1,1.
> 
> Tested-by: Adrien Vergé <adrienverge@gmail.com>
> Signed-off-by: Adrien Vergé <adrienverge@gmail.com>


Paul Bolle

