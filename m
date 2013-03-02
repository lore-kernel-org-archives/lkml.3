Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3CBFh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 00:37:27 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:34182 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3CBFhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 00:37:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHzAVhW7RNqiq3sM97PxTjYJe4UJG6cJaGHv9+smPWedGg@mail.gmail.com>
References: <CAK9yfHw7-LJx31poPqxn_GRfEDyfReqeYTPX7Fqwzi7vtC98UQ@mail.gmail.com>
 <CAGOxZ51EuXnncDf=N7yJ1HR3GgE29Q+oLu-UQGEU0STr1m05AA@mail.gmail.com> <CAK9yfHzAVhW7RNqiq3sM97PxTjYJe4UJG6cJaGHv9+smPWedGg@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Sat, 2 Mar 2013 11:06:41 +0530
Message-ID: <CAGOxZ51roe7id29h-v3cgMQssYscQYy_iWJJ1BgAywu999V79g@mail.gmail.com>
Subject: Re: Boot failure on Origen board using latest kernel
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Padmavathi Venna <padma.v@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 10:26 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Alim,
>
> On 2 March 2013 10:18, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>> Hi Sachin,
>>
>> Looks like exynos4 is not yet moved to the generic dma binding recently
>> merged.
>>
>> Could you try out below:
>
> I forgot to mention in the previous mail that the problem was in non-dt case.
> With the below entries added in exynos4 dtsi file, it boots fine in DT case.
>

Aha, I understand.
But I think the current mainline kernel is broken for __DT case__ also
for exynos4 and that is what my suggested patch fix.
Thanks for you confirmation.

> --
> With warm regards,
> Sachin

--
Regards,
Alim
