Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3CLQGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:06:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56182 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab3CLQGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:06:37 -0400
Date: Tue, 12 Mar 2013 17:06:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: felix-linuxkernel@fefe.de
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: Who is responsible for radeon driver bugs?
Message-ID: <20130312160635.GA5379@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, felix-linuxkernel@fefe.de,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>
References: <20130312160249.GA32182@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130312160249.GA32182@codeblau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's add some more people to CC.

On Tue, Mar 12, 2013 at 05:02:49PM +0100, felix-linuxkernel@fefe.de wrote:
> The radeon driver does not work on my laptop.
> I sent a bug report here a week ago, but got no responses.
> What is the right place to send bug reports for the radeon driver?
> 
> The bug is that LVDS output does not work.  This is, according to lspci,
> a 5000M series Madison Radeon.
> 
> When I insmod the module, the screen stays in text mode and appears
> locked up.
> 
> If something is connected to the HDMI port, I get a framebuffer console
> there.  LVDS stays in broken text mode though.
> 
> When I start X, the HDMI screen turns dark and stays dark and the LVDS
> screen also stays dark and I have to reboot.
> 
> The driver loads the REDWOOD firmware OK.
> 
> Who is responsible for this?  Where do I send my bug report?
> 
> Thanks,
> 
> Felix

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
