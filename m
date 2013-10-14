Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3JNDNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 23:13:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58240 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755520Ab3JNDNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 23:13:35 -0400
Message-ID: <525B615A.2070807@free-electrons.com>
Date: Mon, 14 Oct 2013 05:13:30 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>, nicolas.ferre@atmel.com,
        daniel.lezcano@linaro.org, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clocksource: at91/tc: remove deprecated IRQF_DISABLED
References: <1381639559-6981-1-git-send-email-michael.opdenacker@free-electrons.com> <525A679A.2060408@overkiz.com>
In-Reply-To: <525A679A.2060408@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 10/13/2013 11:27 AM, boris brezillon wrote:
> Hello Micheal,
>
> This flag has been removed in a recent submission (see
> https://lkml.org/lkml/2013/10/2/202), and, if I'm correct, is on his
> way for mainlining.
That's good news. Thank you very much!

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

