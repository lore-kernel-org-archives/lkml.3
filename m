Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbbAHQfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:35:00 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52701 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754479AbbAHQe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:34:59 -0500
Date: Thu, 8 Jan 2015 16:34:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vince Weaver <vince@deater.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150108163450.GV12302@n2100.arm.linux.org.uk>
References: <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
 <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
 <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <20150107205346.GO12302@n2100.arm.linux.org.uk>
 <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
 <20150108103911.GQ12302@n2100.arm.linux.org.uk>
 <alpine.DEB.2.10.1501081044470.26196@pianoman.cluster.toy>
 <20150108161908.GA17290@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108161908.GA17290@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 04:19:08PM +0000, Catalin Marinas wrote:
> I really think we should stop this thread. User ABI breakage fixed now.

No.  Vince's email shows a more serious problem.

The ABI breakage issue was reported before the patches were apparently
merged, but that information seems to have been lost.  We need to
understand how that happened so similar instances don't happen in the
future.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
