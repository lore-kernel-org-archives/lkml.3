Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaAXUqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:46:31 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:58396 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaAXUq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:46:28 -0500
MIME-Version: 1.0
In-Reply-To: <1390594484.15637.2.camel@x220>
References: <1390593374-6592-1-git-send-email-adrienverge@gmail.com>
	<1390594484.15637.2.camel@x220>
Date: Fri, 24 Jan 2014 15:46:27 -0500
Message-ID: <CANsc=4XiKexRwApFDdDi09mrduz6BXQPDTz880ucwJA1SOV27Q@mail.gmail.com>
Subject: Re: [PATCH] ALSA: hda - Fix silent output on MacBook Air 1,1
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "Nicolo'" <nicolopiazzalunga@gmail.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, Hui Wang <hui.wang@canonical.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think very few people use Linux on their MBA 1,1. Moreover, part of
them remained on v2.6.

2014/1/24 Paul Bolle <pebolle@tiscali.nl>:
> On Fri, 2014-01-24 at 14:56 -0500, Adrien Vergé wrote:
>> Similarly to other Apple products, MBA 1,1 needs a specific quirk.
>> Pin 0x18 must be set to VREF_50 to have sound output.  This was no
>> longer done since commit 1a97b7f, resulting in a mute built-in speaker.
>
> Commit 1a97b7f ("ALSA: hda/realtek - Remove the last static quirks for
> ALC882") was included in v3.4. Did no-one notice this for 9 releases?
>
>> This patch corrects the regression by creating a fixup for the MBA 1,1.
>>
>> Tested-by: Adrien Vergé <adrienverge@gmail.com>
>> Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
>
>
> Paul Bolle
>
