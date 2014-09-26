Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaIZMVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:21:33 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:53939 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaIZMVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:21:32 -0400
MIME-Version: 1.0
In-Reply-To: <1411733700.7866.29.camel@x220>
References: <1411733700.7866.29.camel@x220>
Date: Fri, 26 Sep 2014 14:21:31 +0200
X-Google-Sender-Auth: Aezo2CgFSg4CQT31DKwcOOJeLPE
Message-ID: <CAOQ7t2Y0+OMab1CGGegUU+oOPaw=_NAxwM0LKn9GpiMZqAFnvg@mail.gmail.com>
Subject: Re: ARM: meson: MESON6_TIMER?
From: Carlo Caione <carlo@caione.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Carlo Caione <carlo@caione.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 2:15 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Hi Carlo,

Hi Paul,

> Your commit 3b8f5030ddcf ("ARM: meson: add basic support for MesonX
> SoCs") landed in next-20140926. It adds (among other things) a select
> statement:
>     select MESON6_TIMER
>
> But there's no Kconfig symbol MESON6_TIMER (in next-20140926). I assume
> that this symbol is queued somewhere. (Probably related is the currently
> orphaned DT string "amlogic,meson6-timer".) Is that correct?

Yes. The timer support is going to be added with:

http://www.spinics.net/lists/arm-kernel/msg362483.html

Daniel is already on it.

-- 
Carlo Caione
