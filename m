Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaLaVjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 16:39:01 -0500
Received: from omr.mail.isx.net.nz ([111.65.230.130]:19087 "EHLO
	omr.mail.isx.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaLaVi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 16:38:59 -0500
Message-ID: <54A46CEF.3030108@blennerhassett.gen.nz>
Date: Thu, 01 Jan 2015 10:38:55 +1300
From: Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.alsa.devel
To: Takashi Iwai <tiwai@suse.de>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sound: pci: asihpi: hpifunc.c: Remove some unused
 functions
References: <1420039022-10018-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<s5h7fx7hkga.wl-tiwai@suse.de>	<CAKXHbyOEp=juzjaqsNt9RXn02VYDJXvESK4o_vAhMtFGmK=dHA@mail.gmail.com>	<s5hvbkrg44c.wl-tiwai@suse.de>	<CAKXHbyPEr+HOAXB8ibtpYidh_GVD0qAgcQK3A4kXpgVWgLbtQA@mail.gmail.com> <s5hsifvg192.wl-tiwai@suse.de>
In-Reply-To: <s5hsifvg192.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> More code changes may land in near future, so removing functions isn't
>>> good at all at this moment.  We need to wait until the all things are
>>> settled down.  IOW, forget about this for a while :)

Hi Richard, Takashi,

In principle I don't object to this patch (thanks for the work Richard),
but right now I'm really on vacation, and then at LCA so won't be
spending time on it until late January.

How about I take the patch into my tree, and include in my next set of
updates, allowing for any further tweaks to the unused function list.

--
Eliot



