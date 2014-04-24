Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaDXJU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:20:58 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:41149 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbaDXJUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=U_H_RdoMr2R9TAgj9HmaU0zm=UxcvvMXErzQ-acwZJwA@mail.gmail.com>
References: <1398210681-22976-1-git-send-email-dianders@chromium.org>
	<CAPDyKFpzPCi2Yb_33akh5dg1NjudydLkJrdGnQ_xJtsEGGcQ3g@mail.gmail.com>
	<CAD=FV=U_H_RdoMr2R9TAgj9HmaU0zm=UxcvvMXErzQ-acwZJwA@mail.gmail.com>
Date: Thu, 24 Apr 2014 11:14:51 +0200
Message-ID: <CAPDyKFo7Mi9+WJx+7rcB_fqdi59TuY+FhT=Ued9Zi=rhNGnYtA@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Don't print data errors
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The "status" here could be useful information about the status
>> register, which is not considered while printing errors by the "higher
>> levels". An option could be to print the error, but not when you
>> perform tuning.
>>
>> No big deal though, just a thought.
>
> Right, I could potentially put the driver into "tuning" mode and then
> suppress the errors during that time.  If you request it I will do
> that.
>
> I will also note that there are many other error conditions in the
> driver that don't have such printouts.  I think the general philosophy
> of this driver is not to print them...

So, then let's stick to that philosophy and keep this as is.

Kind regards
Ulf Hansson

>
> -Doug
