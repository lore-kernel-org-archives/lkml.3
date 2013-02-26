Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab3BZLaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:30:30 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:43397 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3BZLa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:30:29 -0500
Message-ID: <512C9CD4.50808@linaro.org>
Date: Tue, 26 Feb 2013 12:30:28 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, fweisbec@gmail.com,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/2] time : pass broadcast device parameter
References: <5123C299.3080005@linaro.org> <1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org> <CAKohpomqooF6DzzzdUFByA0wDxQ3RuPne15a9Vy1sScKjZfeyA@mail.gmail.com>
In-Reply-To: <CAKohpomqooF6DzzzdUFByA0wDxQ3RuPne15a9Vy1sScKjZfeyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 09:45 AM, Viresh Kumar wrote:
> On 22 February 2013 03:31, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> The broadcast timer could be passed as parameter to the function
>> instead of using again tick_broadcast_device.evtdev which was
>> previously used in the caller function.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> I know you are going for another round with this patchset and was just
> trying v1.
> 
> I did my tests on ARM Vexpress - TC2, big.LITTLE Arch.
> 
> Tested-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks Viresh for testing.

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

