Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3JUQrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 12:47:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab3JUQrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 12:47:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21093.23168.424554.698941@linux-qknr.site>
Date: Mon, 21 Oct 2013 18:46:56 +0200
From: Egbert Eich <eich@suse.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Egbert Eich <eich@suse.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: HPD flood warning since b8f102e8b
In-Reply-To: jkosina@suse.cz wrote on Thursday, 3 October 2013 at 16:33:20 +0200 
References: <alpine.LNX.2.00.1310031141260.29701@pobox.suse.cz>
	<CAKMK7uEbGZ3_tHTCqOT7H4eViBnYmkPTS210jOvfweSf3gQ_fg@mail.gmail.com>
	<alpine.LNX.2.00.1310031632320.29701@pobox.suse.cz>
X-Mailer: VM 8.2.0b under 24.2.1 (x86_64-suse-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Just found your email, it got missed do to a temporary inaccessibility to
my email.

Jiri Kosina writes:
 > On Thu, 3 Oct 2013, Daniel Vetter wrote:
 > 
 > > Can you please attach full dmesg from boot up to the first WARN with
 > > drm.debug=0xe? This really shouldn't happen and indicates a bug
 > > somewhere ...
 > 
 > A bit difficult ... I originally thought that it was reliably 
 > reproducible, but now I didn't get it after 10 suspend/resume cycles. Will 
 > keep following it, and once it appears, will send you the dmesg.
 > 
Could you check if you get any messages regarding HPD storms after 
suspend/resume ie messages like:
"[drm] HPD interrupt storm detected on connector HDMI-A-1"
but without the annouing warn messages?

I cannot find anything obviously wrong in the code. 
However there are several code paths for different hardware though - could 
you give me an 'lspci -n' output so I can narrow them down?

Thanks!
Cheers,
	Egbert.
