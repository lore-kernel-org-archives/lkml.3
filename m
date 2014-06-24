Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaFXKnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:43:46 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50655 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752217AbaFXKno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:43:44 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] thermal: Bind cooling devices with the correct arguments
References: <1401789598-14967-1-git-send-email-punit.agrawal@arm.com>
	<9hh61jzsuq1.fsf@arm.com> <53A2100C.6080701@codeaurora.org>
Date: Tue, 24 Jun 2014 11:43:35 +0100
In-Reply-To: <53A2100C.6080701@codeaurora.org> (Stephen Boyd's message of
	"Wed, 18 Jun 2014 15:17:48 -0700")
Message-ID: <9hhegyevb8o.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> On 06/17/14 03:20, Punit Agrawal wrote:
>> Ping?
>>
>> Punit Agrawal <punit.agrawal@arm.com> writes:
>>
>>> When binding cooling devices to thermal zones created from the device
>>> tree the minimum and maximum cooling states are in the wrong order
>>> leading to failure to bind.
>>>
>>> Fix the order of cooling states in the call to
>>> thermal_zone_bind_cooling_device to fix this.
>>>
>>> Cc:Zhang Rui <rui.zhang@intel.com>
>>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>
> Ah I ran into the same problem while testing out some thermal DT stuff.
>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks Stephen!

Rui, can you pick this patch?
