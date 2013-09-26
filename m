Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3IZCV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:21:56 -0400
Received: from void.printf.net ([89.145.121.20]:54373 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab3IZCVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:21:55 -0400
From: Chris Ball <cjb@laptop.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Grant Grundler <grundler@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: core: remove issue_fn indirect function call
References: <1379611214-1089-1-git-send-email-grundler@chromium.org>
	<CAPDyKFr0h=uTz4xOAULLc0Ff23xB-xVuuk+XnBz_Uq5YMryHbA@mail.gmail.com>
Date: Wed, 25 Sep 2013 22:21:38 -0400
In-Reply-To: <CAPDyKFr0h=uTz4xOAULLc0Ff23xB-xVuuk+XnBz_Uq5YMryHbA@mail.gmail.com> (Ulf
	Hansson's message of "Fri, 20 Sep 2013 09:33:06 +0200")
Message-ID: <87fvss2uh9.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 20 2013, Ulf Hansson wrote:
> On 19 September 2013 19:20, Grant Grundler <grundler@chromium.org> wrote:
>> struct mmc_queue defines issue_fn as an indirect function call.
>> issue_fn field only gets set to mmc_blk_issue_rq and only gets
>> invoked immediately after calling blk_fetch_request().
>> Don't bother with indirect function call - it's pointless and just
>> obfuscates the code.
>>
>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Thanks, pushed to mmc-next for 3.13.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
