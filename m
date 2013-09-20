Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3ITVLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:11:43 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:38610 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3ITVLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:11:42 -0400
MIME-Version: 1.0
In-Reply-To: <523CB938.8000104@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1379526839-14798-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdZqm=3oed979Jyg7n+8KwW_-2AGv3OzJBTPN20ZH=Vc3Q@mail.gmail.com>
	<CACRpkdauZCi+BDGa9gAZq0eG1jzHBuym5RzzwfxxcCMCAFJZEg@mail.gmail.com>
	<523CB938.8000104@gmail.com>
Date: Fri, 20 Sep 2013 23:11:41 +0200
Message-ID: <CACRpkdagqLKr6WqzHLCa9N27HMYcZkgW25UABLNPaT89fgXgkw@mail.gmail.com>
Subject: Re: [PATCH 01/26] ARM: nomadik: move mtu setup to clocksource init
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 11:08 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> Ok, well I was looking at v3.12-rc1 and did not really follow other
> nomadik related threads. That time ux500 wasn't tangled up with
> clk-nomadik.

Well yeah, you're right. But Lee has a pending patch set that
makes the ux500 use this for its OF boot path...

Yours,
Linus Walleij
