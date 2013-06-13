Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab3FMRZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:25:06 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61660 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3FMRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <9948950.GZ51yJYkxQ@flatron>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
	<9948950.GZ51yJYkxQ@flatron>
Date: Thu, 13 Jun 2013 10:25:02 -0700
X-Google-Sender-Auth: c_tKl9R0NsxGcTuGmf9_aXl-DDM
Message-ID: <CAD=FV=Un+Ti8atZLUbK+5w=dB7vX7HoxVacEGkjvCboVo4mNpA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, Jun 13, 2013 at 10:13 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Thursday 13 of June 2013 10:05:44 Doug Anderson wrote:
>> It's convenient if get_maintainer suggests sending samsung/exynos
>> pinctrl changes to linux-samsung-soc and to Kukjin.  Add an entry for
>> that.
>
> Well, if we are already at it, we could list the actual maintainers of the
> driver.
>
> The original maintainer was Thomas Abraham <thomas.abraham@linaro.org>
> (added to CC) and after joining to development of this driver last year I
> have become a de facto maintainer as well, so...
>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  MAINTAINERS | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 8d97b3e..d026e38 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6284,6 +6284,16 @@ L:     linux-arm-kernel@lists.infradead.org
>> (moderated for non-subscribers) S:    Maintained
>>  F:   drivers/pinctrl/pinctrl-at91.c
>>
>> +PIN CONTROLLER - SAMSUNG
>> +M:   Linus Walleij <linus.walleij@linaro.org>
>> +M:   Kukjin Kim <kgene.kim@samsung.com>
>
> So actually this would be:
> M:      Thomas Abraham <thomas.abraham@linaro.org>
> M:      Tomasz Figa <t.figa@samsung.com>
>
> Thomas, do you agree on this?

Ah.  Wasn't sure where the official maintainership should lie.  ;)  If
Thomas is happy with this then I'll spin and re-send.  Shall I remove
Kukjin and Linus, then?  It's convenient to have Linus on the list
since he tends to be the one applying the patches...

-Doug
