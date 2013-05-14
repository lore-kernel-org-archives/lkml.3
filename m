Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab3ENUfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:35:23 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:41509 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3ENUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:35:22 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20130514181318.10068.79002@quantum>
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
	<1366388904-13903-3-git-send-email-james.hogan@imgtec.com>
	<20130514181318.10068.79002@quantum>
Date: Tue, 14 May 2013 21:35:20 +0100
X-Google-Sender-Auth: PgiNNeFKXGwXiJktNbKCrXK5P6o
Message-ID: <CAAG0J9_ScDGDvk4NF_ojLb1MgB0mA60htR3ay2Z4EvFvNRT1Dw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] clk: add support for clock reparent on set_rate
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2013 19:13, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting James Hogan (2013-04-19 09:28:23)
>> Add core support to allow clock implementations to select the best
>> parent clock when rounding a rate, e.g. the one which can provide the
>> closest clock rate to that requested. This is by way of adding a new
>> clock op, determine_rate(), which is like round_rate() but has an extra
>> parameter to allow the clock implementation to optionally select a
>> different parent clock. The core then takes care of reparenting the
>> clock when setting the rate.
>>
>
> Hi James,
>
> Can you rebase this onto -rc1?  It does not apply cleanly.

Hi Mike,

Sure, I rebased onto clk-next the other day so I'll update to rc1 and
resubmit tomorrow.

Cheers
James
