Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3I2P5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:57:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50979 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753922Ab3I2P47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:56:59 -0400
Message-ID: <52484DBF.7000805@free-electrons.com>
Date: Sun, 29 Sep 2013 17:56:47 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] PWM: atmel-pwm: add PWM controller driver
References: <1380079664-21959-1-git-send-email-voice.shen@atmel.com> <5245B7D7.2040405@free-electrons.com> <5247FABD.9070405@atmel.com>
In-Reply-To: <5247FABD.9070405@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/2013 12:02, Bo Shen wrote:
> Hi Alexandre,
> [snip]
> Thank for point out this.
>
> I see you have sent out a patch to fix it (however the other contents
> of your patch doesn't work). So, do you prefer I send out v5 patch to
> fix this? or you fix your patch at same time fix this issue?

I think it would be better that you fix that particular part in a v5 and
I'll respin my patch for request/free based on that


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

