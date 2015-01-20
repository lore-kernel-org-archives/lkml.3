Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbbATKyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:54:36 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:13183 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbbATKyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:54:33 -0500
Message-ID: <54BE3369.9000802@imgtec.com>
Date: Tue, 20 Jan 2015 07:52:25 -0300
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        James Hartley <james.hartley@imgtec.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH v8 0/2] Imagination Technologies PWM support
References: <1420826088-13113-1-git-send-email-ezequiel.garcia@imgtec.com>
In-Reply-To: <1420826088-13113-1-git-send-email-ezequiel.garcia@imgtec.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.100.200.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/2015 02:54 PM, Ezequiel Garcia wrote:
> A new round for the IMG PWM driver.
> 
> The IMG PWM controller is muxed with a PDM controller, through a shared
> so-called periph register bit, which sets the output as PWM or PDM.
> Because this register is not part of the pin controller block, but rather
> PWM/PDM specific, and because the register is also used to set the PDM value,
> it is simpler to use a regmap-based syscon to deal with it.
> 
> This time, I'm removing the PDM driver from the submission and submitting the PWM
> alone. The PDM was written as a misc driver, but had some design issues, so for
> now I'm proposing to merge the PWM only.
> 
> The series is based on v3.19-rc3. If at all possible I'd like to see this merged
> for v3.20.
> 

Thierry,

Any comments on this? Any chance we merge it in time for v3.20?
It's -rc5 already and I've started to worry.

Thanks!
-- 
Ezequiel
