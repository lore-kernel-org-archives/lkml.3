Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3CBE4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:56:06 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45409 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CBE4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:56:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAGOxZ51EuXnncDf=N7yJ1HR3GgE29Q+oLu-UQGEU0STr1m05AA@mail.gmail.com>
References: <CAK9yfHw7-LJx31poPqxn_GRfEDyfReqeYTPX7Fqwzi7vtC98UQ@mail.gmail.com>
	<CAGOxZ51EuXnncDf=N7yJ1HR3GgE29Q+oLu-UQGEU0STr1m05AA@mail.gmail.com>
Date: Sat, 2 Mar 2013 10:26:03 +0530
Message-ID: <CAK9yfHzAVhW7RNqiq3sM97PxTjYJe4UJG6cJaGHv9+smPWedGg@mail.gmail.com>
Subject: Re: Boot failure on Origen board using latest kernel
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Alim Akhtar <alim.akhtar@gmail.com>
Cc: Padmavathi Venna <padma.v@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alim,

On 2 March 2013 10:18, Alim Akhtar <alim.akhtar@gmail.com> wrote:
> Hi Sachin,
>
> Looks like exynos4 is not yet moved to the generic dma binding recently
> merged.
>
> Could you try out below:

I forgot to mention in the previous mail that the problem was in non-dt case.
With the below entries added in exynos4 dtsi file, it boots fine in DT case.

-- 
With warm regards,
Sachin
