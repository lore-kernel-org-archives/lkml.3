Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3ITVWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:22:30 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57772 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3ITVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <523CBA5F.60901@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1379526839-14798-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<523CBA5F.60901@gmail.com>
Date: Fri, 20 Sep 2013 23:22:29 +0200
Message-ID: <CACRpkdZDoBDrF0A4KFUeJxw0cZzL8dLcRTFzhxY0ZRKET8T7bg@mail.gmail.com>
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

On Fri, Sep 20, 2013 at 11:13 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> Linus,
>
> looking at the fix you posted at [1], can I assume that the above it
> redundant and can be removed?
>
> [1] http://marc.info/?l=linux-arm-kernel&m=137910161418706&w=2

I think so, post a version doing that and I'll test it along with my other
patch.

If it blows up I'll notice :-)

Yours,
Linus Walleij
