Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3CBFsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 00:48:30 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:34418 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3CBFs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 00:48:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHzAVhW7RNqiq3sM97PxTjYJe4UJG6cJaGHv9+smPWedGg@mail.gmail.com>
References: <CAK9yfHw7-LJx31poPqxn_GRfEDyfReqeYTPX7Fqwzi7vtC98UQ@mail.gmail.com>
	<CAGOxZ51EuXnncDf=N7yJ1HR3GgE29Q+oLu-UQGEU0STr1m05AA@mail.gmail.com>
	<CAK9yfHzAVhW7RNqiq3sM97PxTjYJe4UJG6cJaGHv9+smPWedGg@mail.gmail.com>
Date: Sat, 2 Mar 2013 11:18:28 +0530
Message-ID: <CAAgF-Bd3gBGrG6CFfsqnNZ8ORqEbfwvtVYop2=0xd6Poamaqaw@mail.gmail.com>
Subject: Re: Boot failure on Origen board using latest kernel
From: Padma Venkat <padma.kvr@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Alim Akhtar <alim.akhtar@gmail.com>,
        Padmavathi Venna <padma.v@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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

For non-dt case I tested on 6410 board where it is using different DMA
controller. I will a send patch to fix this.

Thanks
Padma
>
> --
> With warm regards,
> Sachin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
