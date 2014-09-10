Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbaIJE6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:58:03 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:58455 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIJE6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:58:01 -0400
MIME-Version: 1.0
In-Reply-To: <04ab01cfcbe0$caeac4d0$60c04e70$@kernel.org>
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>
	<CABxcv==ycrPw1MTv7X0baX2WfqgDS+4EEfGAWc+ZhpiR6=Uy+Q@mail.gmail.com>
	<04ab01cfcbe0$caeac4d0$60c04e70$@kernel.org>
Date: Tue, 9 Sep 2014 21:58:00 -0700
X-Google-Sender-Auth: BBzGf0ZR9KaM119DU_q_k0Zr-to
Message-ID: <CAD=FV=UuT_78kWS274jY1y69XQoYCadgfAHXjdBaJdJDsVk-pw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Add max77802 support for Peach boards
From: Doug Anderson <dianders@chromium.org>
To: kgene@kernel.org
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 8, 2014 at 8:47 PM,  <kgene@kernel.org> wrote:
> Javier Martinez Canillas wrote:
>>
>> Hello Kukjin,
>>
> Hi,
>
>> On Wed, Aug 20, 2014 at 1:19 PM, Javier Martinez Canillas
>> <javier.martinez@collabora.co.uk> wrote:
>> >
>> > This is a second version of the series that adds max77802 support for
>> > the Peach Pit and Pi boards. The series also have all the pending
>> > patches that were posted but depended on this support. I've picked
>> > all the patches I found and rebased them to be sure that they apply
>> > cleanly on top of linux-next. Also I've taken some DT snippets from
>> > the downstream Chrome OS 3.8 kernel DTS for devices that use one of
>> > these regulators as their input supply.
>> >
>>
>> Any comments on this series?
>>
> Looks good to me but I just wanted to get ack from chrome guy, Doug? But since
> Naveen tested, it should be fine I think. I'll take the series.

I haven't had crazy amounts of time to review pit/pi patches recently,
but luckily Javier has been picking up my slack.  I think he's more of
a maintainer for these file than I am at this point.

...but I did do a quick skim / compare to our tree and found one small
bug (see patch #1) and added my Reviewed-by tags.

-Doug


-Doug
