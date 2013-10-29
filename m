Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3J2TEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:04:13 -0400
Received: from fifo99.com ([67.223.236.141]:38062 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab3J2TEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:04:11 -0400
Date: Tue, 29 Oct 2013 12:03:58 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Olof Johansson <olof@lixom.net>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
Message-ID: <20131029190358.GB13047@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
 <20131029132043.GA28165@fifo99.com>
 <CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
 <20131029170817.GA13047@fifo99.com>
 <CAOesGMgKbreaqFTGvC=_T6-i7uejfXAPNU8LmMpgDMqeEwYxZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgKbreaqFTGvC=_T6-i7uejfXAPNU8LmMpgDMqeEwYxZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:39:45AM -0700, Olof Johansson wrote:
> On Tue, Oct 29, 2013 at 10:08 AM, Daniel Walker <dwalker@fifo99.com> wrote:
> 
> > Personally I think splitting mach- stuff isn't very useful or
> > interesting.. There's just no technical reason for it, for example x86
> > and x86_64 was a win from my perspective , there's a lot more reason to
> > keep similar things together than to split things up.
> 
> There are definitely valid technical reasons for it; the old and new
> platforms share no code, and the legacy platforms are unlikely to be
> updated to modern infrastructure anytime soon. Other platforms are
> managed in similar manners, such as OMAP, imx/mxs, etc.

Are you speaking from a meta perspective , or you have specific example
in msm code ?


Daniel
