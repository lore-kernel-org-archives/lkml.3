Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbbAPMmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:42:31 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:24328 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbAPMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:42:30 -0500
X-ME-Helo: beldin
X-ME-Date: Fri, 16 Jan 2015 13:42:28 +0100
X-ME-IP: 109.214.23.205
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mike Turquette <mturquette@linaro.org>
Cc: "Daniel Mack" <daniel@zonque.org>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] clk: pxa: add missing pxa27x clocks for Irda and sa1100-rtc
References: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
	<1419688528-760-5-git-send-email-robert.jarzmik@free.fr>
	<20150112235256.20842.68349@quantum>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 16 Jan 2015 13:42:27 +0100
In-Reply-To: <20150112235256.20842.68349@quantum> (Mike Turquette's message of
	"Mon, 12 Jan 2015 15:52:56 -0800")
Message-ID: <87sifax5fw.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Turquette <mturquette@linaro.org> writes:

> Quoting Robert Jarzmik (2014-12-27 05:55:28)
>> Add 2 clocks which were erronously forgotten by the clock framework
>> port, namely :
>>  - sa1100-rtc
>>  - irda for pxa2xx-ir:UARTCLK
>> 
>> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
>
> Acked-by: Michael Turquette <mturquette@linaro.org>

Thanks for the review and the ack Michael, I'll push that in pxa/for-next.

Cheers.

--
Robert
