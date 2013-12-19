Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3LSADu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:03:50 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47035 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3LSADs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:03:48 -0500
Date: Thu, 19 Dec 2013 00:03:46 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: cirrusdrmfb broken with simplefb
Message-ID: <20131219000346.0f722b65@alan.etchedpixels.co.uk>
In-Reply-To: <20131218092941.GA19210@gmail.com>
References: <s5hlhzik3kk.wl%tiwai@suse.de>
	<CANq1E4TFKDduy71jCXy+8CMS1_OFxWEpsHY3AA0RUJPW4VE8hg@mail.gmail.com>
	<20131218092941.GA19210@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That bug always existed, simplefb is just the first driver to hit it 
> > (vesafb/efifb didn't use resources). I'm aware of the issue but as a 
> > workaround you can simply disable CONFIG_X86_SYSFB. That restores 
> > the old behavior.
> 
> This looks like a regression, so we'll either need a fix or we'll have 
> to mark CONFIG_X86_SYSFB as CONFIG_BROKEN.

Kernel bugzilla has entries for simplefb breaking both vesafb and matrox
mga.


