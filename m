Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3IZBZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:25:52 -0400
Received: from void.printf.net ([89.145.121.20]:49550 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab3IZBZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:25:41 -0400
From: Chris Ball <cjb@laptop.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Grant Grundler <grundler@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: core: remove dead function mmc_try_claim_host
References: <1379640096-32383-1-git-send-email-grundler@chromium.org>
	<CAPDyKFrLpVGp4qmObJ1w2pufDTPQ0ssLRxFpRYHUtMq9Vu9KMA@mail.gmail.com>
Date: Wed, 25 Sep 2013 21:25:23 -0400
In-Reply-To: <CAPDyKFrLpVGp4qmObJ1w2pufDTPQ0ssLRxFpRYHUtMq9Vu9KMA@mail.gmail.com> (Ulf
	Hansson's message of "Fri, 20 Sep 2013 09:35:09 +0200")
Message-ID: <87txh84bng.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 20 2013, Ulf Hansson wrote:
> On 20 September 2013 03:21, Grant Grundler <grundler@chromium.org> wrote:
>> cscsope says there are no callers for mmc_try_claim_host in the kernel.
>> No reason to keep it.
>>
>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Thanks, pushed to mmc-next for 3.13 with Ulf's ACK.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
