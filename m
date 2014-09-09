Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaIII0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:26:45 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63972 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaIII0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:26:41 -0400
Message-ID: <540EB9C2.3070401@linaro.org>
Date: Tue, 09 Sep 2014 09:26:42 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v3 0/5] arm: Implement arch_trigger_all_cpu_backtrace
References: <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org> <1410190115-32604-1-git-send-email-daniel.thompson@linaro.org> <20140908162449.GD12361@n2100.arm.linux.org.uk>
In-Reply-To: <20140908162449.GD12361@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/14 17:24, Russell King - ARM Linux wrote:
> On Mon, Sep 08, 2014 at 04:28:30PM +0100, Daniel Thompson wrote:
>> * Restructured to sit nicely on a similar FYI patchset from Russell
>>   King. It now effectively replaces the work in progress final patch
>>   with something much more complete.
> 
> I'd suggest that patch 2 should be in a different place - get the FIQ
> infrastructure in place first before adding any users of it would be
> a much more sensible patch ordering.

Ok. I will push this to the back.
