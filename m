Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbbATIgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:36:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56563 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbATIgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:36:19 -0500
Date: Tue, 20 Jan 2015 09:36:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, intel-gfx@lists.freedesktop.org,
        "dri-devel@lists.freedesktop.org >> DRI" 
	<dri-devel@lists.freedesktop.org>
Subject: Re: Logged messages from i915 using kernel 3.19-rc4
Message-ID: <20150120083617.GA5046@nazgul.tnic>
References: <54BE00F6.9000900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54BE00F6.9000900@lwfinger.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 01:17:10AM -0600, Larry Finger wrote:
> Hi,
> 
> I just discovered almost 100 of the following entries in my log:
> 
> [drm:intel_uncore_check_errors [i915]] *ERROR* Unclaimed register before interrupt
> 
> Those were accumulated in about 12 hours of operation. I also have one that says
> 
> i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment

I got different ones on rc5 :)

[    0.970103] [drm:intel_set_pch_fifo_underrun_reporting] *ERROR* uncleared pch fifo underrun on pch transcoder A
[    0.970107] [drm:intel_pch_fifo_underrun_irq_handler] *ERROR* PCH transcoder A FIFO underrun

and I'm wondering whether those can be simply shut up or we can actually
do something about them...

Thanks.

-- 
Regards/Gruss,
    Boris.
--
