Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbaFRA1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:27:14 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33790 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbaFRA1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:27:12 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mporter@linaro.org, patches@linaro.org, bjorn@kryo.se,
        ashwin.chaugule@linaro.org, gregkh@linuxfoundation.org, s-anna@ti.com,
        loic.pallardy@st.com, lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, pawel.moll@arm.com, robh+dt@kernel.org,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com
Subject: Re: [PATCHv7 2/5] mailbox: Introduce framework for mailbox
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
	<1402592479-7244-1-git-send-email-jaswinder.singh@linaro.org>
Date: Tue, 17 Jun 2014 17:27:09 -0700
In-Reply-To: <1402592479-7244-1-git-send-email-jaswinder.singh@linaro.org>
	(Jassi Brar's message of "Thu, 12 Jun 2014 22:31:19 +0530")
Message-ID: <7hionz9i5e.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jassi Brar <jaswinder.singh@linaro.org> writes:

> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
>
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h
>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>

This series is shaping up nicely.  The one thing I think it would
benefit from, being a new common framework is something under
Documentation giving a brief overview, but more importantly some 
example code snippets of a mailbox client using the API, and maybe an
example usage of the controller API as well.

Not only will that guide developers who want to use/implement this API
on their platforms, it will also aid reviewers.

Thanks,

Kevin
