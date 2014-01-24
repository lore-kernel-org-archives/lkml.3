Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaAXVIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:08:13 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53122 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290AbaAXVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:08:07 -0500
Message-ID: <1390597685.15637.6.camel@x220>
Subject: Re: [PATCH] ALSA: hda - Fix silent output on MacBook Air 1,1
From: Paul Bolle <pebolle@tiscali.nl>
To: Adrien =?ISO-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "Nicolo'" <nicolopiazzalunga@gmail.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, Hui Wang <hui.wang@canonical.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 24 Jan 2014 22:08:05 +0100
In-Reply-To: <CANsc=4XiKexRwApFDdDi09mrduz6BXQPDTz880ucwJA1SOV27Q@mail.gmail.com>
References: <1390593374-6592-1-git-send-email-adrienverge@gmail.com>
	 <1390594484.15637.2.camel@x220>
	 <CANsc=4XiKexRwApFDdDi09mrduz6BXQPDTz880ucwJA1SOV27Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jan 2014 21:08:05.0857 (UTC) FILETIME=[60276D10:01CF1948]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 15:46 -0500, Adrien Vergé wrote:
> I think very few people use Linux on their MBA 1,1. Moreover, part of
> them remained on v2.6.

I see. Well, if your analysis is correct I think you're supposed to add
     Fixes: 1a97b7f22774 ("ALSA: hda/realtek - Remove the last static quirks for ALC882")

to your commit explanation. Not sure, since this tag is not documented,
as far as I can see.


Paul Bolle

