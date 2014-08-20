Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaHTM3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:29:14 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:50990 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaHTM3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:29:12 -0400
Date: Wed, 20 Aug 2014 13:29:02 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andreas Mohr <andi@lisas.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140820132902.7eed767f@alan.etchedpixels.co.uk>
In-Reply-To: <s5htx57hc89.wl-tiwai@suse.de>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
	<20140820051815.GA1109@core.coreip.homeip.net>
	<s5hwqa3hetu.wl-tiwai@suse.de>
	<20140820063130.GA11226@core.coreip.homeip.net>
	<s5htx57hc89.wl-tiwai@suse.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's the gameport core code that is currently broken under some
> situation, right?  If so, marking it as broken is the first step, and
> we don't need to touch else.  We may fix it later, or we may not.  If
> the thing isn't improved, then we can drop the whole stuff.

It's only broken on x86 with frequency changing. x86 is not the only
platform with ISA or PCI bus or gameports.

It really ought to go via staging, and the other arch maintainers be
asked. The m68k and mips world does include a department of relics and
retro-computing 8)

I suspect nobody cares however.

Alan
