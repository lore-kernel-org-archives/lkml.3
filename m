Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3ETQQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:16:36 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59719 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3ETQQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:16:35 -0400
Message-ID: <519A4C5E.1030905@samsung.com>
Date: Tue, 21 May 2013 01:16:30 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] pinctrl: samsung: fix suspend/resume functionality
References: <1368746388-20194-1-git-send-email-dianders@chromium.org>	<1368765198-25550-1-git-send-email-dianders@chromium.org>	<CACRpkdZ1zBrp+jpgw8o_PVd_bcQMpkFXvRAwfJH6KCztT4jx+w@mail.gmail.com> <CAD=FV=XOiVdkEhYu+u-aGkD0DpxWn369uD_r4Pmw=7gHKLjOuQ@mail.gmail.com>
In-Reply-To: <CAD=FV=XOiVdkEhYu+u-aGkD0DpxWn369uD_r4Pmw=7gHKLjOuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/13 23:59, Doug Anderson wrote:
> Linus,
>
> On Mon, May 20, 2013 at 4:47 AM, Linus Walleij<linus.walleij@linaro.org>  wrote:
>> Looks good to me.
>> Acked-by: Linus Walleij<linus.walleij@linaro.org>
>>
>> How are you going to merge this?
>>
>> Samsung tree?
>>
>> My pinctrl development tree?
>>
>> Or my fixes tree, if it's a regression for v3.10?
>
> It is a regression for v3.10 so it would be nice to get it in there
> (Tomasz's patches, too).
>
> It looks like the majority of recent commits to this file went through
> your tree and that seems fine to me unless anyone else on this thread
> has objections.
>
Linus, I'm fine on this. Please take this into your fixes tree with my 
ack, if you want:

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin
