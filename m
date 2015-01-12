Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbbALLGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:06:32 -0500
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:35403 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbbALLG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:06:29 -0500
X-ME-Helo: beldin
X-ME-Date: Mon, 12 Jan 2015 12:06:27 +0100
X-ME-IP: 109.222.243.71
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mike Turquette <mturquette@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Daniel Mack <daniel@zonque.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Transition of pxa25x and pxa27x to clock framework
In-Reply-To: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr> (Robert
	Jarzmik's message of "Sat, 27 Dec 2014 14:55:24 +0100")
References: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 12 Jan 2015 12:06:25 +0100
Message-ID: <87y4p8xnpq.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Once reviewed, I'd like this serie to go through the pxa tree. Therefore an ack
> from Mike is necesary for the last patch (add missing pxa27x clocks).
>
> This is targeted at 3.20 window.
Well, no review is good news ... or not. Mike I still need an ack for patch 4/4,
and then I'll schedule these patches for 3.21 window.

Cheers.

--
Robert
