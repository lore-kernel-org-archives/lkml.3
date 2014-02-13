Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaBMAyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:54:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46625 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBMAyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:54:07 -0500
Message-ID: <52FC17AF.1080508@codeaurora.org>
Date: Wed, 12 Feb 2014 16:54:07 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [RFC/PATCH 2/3] arm: Add ARCH_WANT_OF_RANDOMNESS
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> < 1392168805-14200-3-git-send-email-lauraa@codeaurora.org> <20140212164907.0E958C407C9@trevor.secretlab.ca>
In-Reply-To: <20140212164907.0E958C407C9@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/2014 8:49 AM, Grant Likely wrote:
> On Tue, 11 Feb 2014 17:33:24 -0800, Laura Abbott <lauraa@codeaurora.org> wrote:
>> The stack canary for ARM is currently the same across reboots
>> due to lack of randomness early enough. Add ARCH_WANT_OF_RANDOMNESS
>> to allow devices to add whatever randomness they need.
>>
>> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
>
> Do you have a draft patch for a user of this yet?
>

I had a particular patch in mind but I need to re-work it to work with 
the upstream tree. I wanted to at least send out the infrastructure to 
see how open people were to the idea. After reading the comments, I have 
a couple more ideas of users as well. I'll see if I can work that in for v2.

> g.
>

Thanks,
Laura


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
