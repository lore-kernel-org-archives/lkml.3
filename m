Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaJ0LTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:19:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53451 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaJ0LTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:19:40 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-66-544e2a4995ab
Message-id: <544E2A46.7070106@samsung.com>
Date: Mon, 27 Oct 2014 12:19:34 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v6 4/7] ARM: l2c: Add support for overriding prefetch
 settings
References: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
 <1414407950-3029-5-git-send-email-m.szyprowski@samsung.com>
 <20141027111404.GW12379@n2100.arm.linux.org.uk>
In-reply-to: <20141027111404.GW12379@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4FV1PLb8QgzknuSwezX/MbNG74Cqb
	xdmmN+wW2ztnsFtM+bOcyWLT42usFpd3zWGzmL2kn8Vixvl9TBa3L/NanNu+hcVi6fWLTBav
	+9YwW6za9YfRYv8VLwd+jzXz1jB6tDT3sHl8+zqJxeNyXy+Tx6LvWR47Z91l97hzbQ+bx+Yl
	9R59W1Yxehy/sZ3J4/MmuQDuKC6blNSczLLUIn27BK6MrgcXmQqucFRM+vuarYGxi72LkZND
	QsBEYvu7aVC2mMSFe+vZuhi5OIQEljJK7GlaygLhfGKUmLFqGnMXIwcHr4CWxOmGQJAGFgFV
	iePtC5hBbDYBQ4mut11sILaoQIzE/Z2rwWxeAUGJH5PvsYDYIgKmEtcePWMGmckssJZZ4v7t
	W2DNwgIhEhv23GWGWLadUeLq/qNsIMs4BWwk5i6QBKlhFjCT+PLyMCuELS+xec1b5gmMArOQ
	7JiFpGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUJi7csOxsXHrA4xCnAwKvHw
	7pjmGyLEmlhWXJl7iFGCg1lJhNfxJ1CINyWxsiq1KD++qDQntfgQIxMHp1QDo3365YyVYmd3
	zl6Um213+3W7n3ji6im+1q+YyyxWPv+nkbHJv+dnUodL0cGclQX6Hfq2j9fcrpPRfHpCsIV/
	Rd3fkwpCtnZyJc/f1F1pZvwf9/y3JdNrLYefj7IENvo+Tnzi/Nd82y63XKlnT18v3+W6v0Vu
	mZhi1lXvOK3i/uMztyU9n/U3UYmlOCPRUIu5qDgRALNJZA6TAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-27 12:14, Russell King - ARM Linux wrote:
> On Mon, Oct 27, 2014 at 12:05:47PM +0100, Marek Szyprowski wrote:
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
>> settings configured in registers leading to crashes if L2C is enabled
>> without overriding them. This patch introduces bindings to enable
>> prefetch settings to be specified from DT and necessary support in the
>> driver.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> [mszyprow: rebased onto v3.18-rc1, added error messages when property value
>>   is missing]
> Why?  What if the boot loader has already set these up appropriately?  Why
> should we force people to list these in the DT?

The error message is displayed only when user provided prefetch related
properties without any value (empty properties). Something that Mark Rutland
requested here: https://lkml.org/lkml/2014/9/24/426 I'm sorry if I didn't
describe it clearly enough.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

