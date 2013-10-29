Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab3J2Rjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:39:47 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:40546 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510Ab3J2Rjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:39:45 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131029170817.GA13047@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
	<1382993006-27359-3-git-send-email-davidb@codeaurora.org>
	<20131029132043.GA28165@fifo99.com>
	<CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
	<20131029170817.GA13047@fifo99.com>
Date: Tue, 29 Oct 2013 10:39:45 -0700
Message-ID: <CAOesGMgKbreaqFTGvC=_T6-i7uejfXAPNU8LmMpgDMqeEwYxZQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
From: Olof Johansson <olof@lixom.net>
To: Daniel Walker <dwalker@fifo99.com>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:08 AM, Daniel Walker <dwalker@fifo99.com> wrote:

> Personally I think splitting mach- stuff isn't very useful or
> interesting.. There's just no technical reason for it, for example x86
> and x86_64 was a win from my perspective , there's a lot more reason to
> keep similar things together than to split things up.

There are definitely valid technical reasons for it; the old and new
platforms share no code, and the legacy platforms are unlikely to be
updated to modern infrastructure anytime soon. Other platforms are
managed in similar manners, such as OMAP, imx/mxs, etc.


-Olof
