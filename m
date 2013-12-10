Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab3LJE4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 23:56:22 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39333 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992Ab3LJE4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 23:56:19 -0500
Message-ID: <52A69EEE.7080904@free-electrons.com>
Date: Tue, 10 Dec 2013 05:56:14 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, daniel.lezcano@linaro.org,
        tglx@linutronix.de, thierry.reding@gmail.com
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] clocksource: tegra: remove deprecated IRQF_DISABLED
References: <1381639360-6920-1-git-send-email-michael.opdenacker@free-electrons.com> <1386581745-4559-1-git-send-email-michael.opdenacker@free-electrons.com> <52A5F899.1070706@wwwdotorg.org>
In-Reply-To: <52A5F899.1070706@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 06:06 PM, Stephen Warren wrote:
> On 12/09/2013 02:35 AM, Michael Opdenacker wrote:
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
> I assume that the maintainers for drivers/clocksource/ will apply this.
> If not, let me know, and I can take it through the Tegra tree.
>
Yes, Daniel Lezcano told me he applied the 3 patches I sent (thanks!).

Thank you for your support!

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

