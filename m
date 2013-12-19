Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3LSTT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:19:57 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64867 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LSTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:19:54 -0500
Date: Thu, 19 Dec 2013 20:19:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        the arch/x86 maintainers <x86@kernel.org>, linux-fbdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] x86: sysfb: remove sysfb when probing real hw
Message-ID: <20131219191950.GA564@gmail.com>
References: <1387374611-12493-1-git-send-email-dh.herrmann@gmail.com>
 <1387448038-8260-1-git-send-email-dh.herrmann@gmail.com>
 <52B340CB.90807@wwwdotorg.org>
 <20131219185517.GA303@gmail.com>
 <52B34454.1040603@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B34454.1040603@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Warren <swarren@wwwdotorg.org> wrote:

> On 12/19/2013 11:55 AM, Ingo Molnar wrote:
> > 
> > * Stephen Warren <swarren@wwwdotorg.org> wrote:
> > 
> >> On 12/19/2013 03:13 AM, David Herrmann wrote:
> >>> With CONFIG_X86_SYSFB=y, probing real hw-drivers may result in
> >>> resource-conflicts and drivers will refuse to load. A call to
> >>> request_mem_region() will fail, if the region overlaps with the mem-region
> >>> used by simplefb. The common desktop DRM drivers (intel, nouveau, radeon)
> >>> are not affected as they don't reserve their resources, but some others
> >>> do, including (nvidiafb, cirrus, ..).
> >>
> >> I have validated that this doesn't cause any regressions on the/a
> >> non-x86 platform using simplefb, although given the main point of this
> >> patch is to fix issues on x86, I'm rather hesitant to give a tested-by
> >> tag in case someone looking back interprets it incorrectly:-)
> > 
> > Tested-on-ARM-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> I suppose with CC: stable there's some precedent for a comment after the
> tag, so perhaps:
> 
> Tested-by: Stephen Warren <swarren@wwwdotorg.org> # on ARM only

That works too.

Thanks,

	Ingo
