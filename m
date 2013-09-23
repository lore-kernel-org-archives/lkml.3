Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3IWV6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:58:39 -0400
Received: from void.printf.net ([89.145.121.20]:35556 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3IWV6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:58:38 -0400
From: Chris Ball <cjb@laptop.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: core: remove dead function mmc_try_claim_host
References: <1379640096-32383-1-git-send-email-grundler@chromium.org>
	<CAPDyKFrLpVGp4qmObJ1w2pufDTPQ0ssLRxFpRYHUtMq9Vu9KMA@mail.gmail.com>
	<CANEJEGvEx9YFJ5iFwzqY1jQG9Y+7Fsk1GJqbx6hvveJQ-w2rPQ@mail.gmail.com>
Date: Mon, 23 Sep 2013 22:58:34 +0100
In-Reply-To: <CANEJEGvEx9YFJ5iFwzqY1jQG9Y+7Fsk1GJqbx6hvveJQ-w2rPQ@mail.gmail.com>
	(Grant Grundler's message of "Mon, 23 Sep 2013 14:56:47 -0700")
Message-ID: <86zjr3ci9h.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mon, Sep 23 2013, Grant Grundler wrote:
> On Fri, Sep 20, 2013 at 12:35 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 20 September 2013 03:21, Grant Grundler <grundler@chromium.org> wrote:
>>> cscsope says there are no callers for mmc_try_claim_host in the kernel.
>>> No reason to keep it.
>>>
>>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>>
>> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> Thank you Ulf!
>
> In which maintainer's git tree/branch should I expect this patch to land?
>
> Just looking for some confirmation that it was applied.

I'll take this into mmc-next soon.  Thanks!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
