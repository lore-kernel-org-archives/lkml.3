Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaAMR7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:59:20 -0500
Received: from void.printf.net ([89.145.121.20]:60310 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaAMR7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:59:18 -0500
From: Chris Ball <chris@printf.net>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] mmc: atmel-mci: add vmmc-supply support
References: <1382006808-22728-1-git-send-email-alexandre.belloni@free-electrons.com>
	<CAPDyKFoiWOE47DWrUHNWVPyihL=uCidpd52TV1vgUbq1aMNvbw@mail.gmail.com>
	<52B09FF0.4070200@free-electrons.com>
	<20131218081645.GA4268@ldesroches-Latitude-E6320>
	<52D425CF.9050507@free-electrons.com>
Date: Mon, 13 Jan 2014 17:59:16 +0000
In-Reply-To: <52D425CF.9050507@free-electrons.com> (Alexandre Belloni's
	message of "Mon, 13 Jan 2014 18:43:43 +0100")
Message-ID: <867ga3daq3.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 13 2014, Alexandre Belloni wrote:
> I still don't see that on mmc.git, Any issue with that patch ? I would
> prefer not missing the 3.14 merge window.

Sorry about that -- just pushed to mmc-next for 3.14 with ACKs from
Ulf and Ludovic.  Thanks,

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
