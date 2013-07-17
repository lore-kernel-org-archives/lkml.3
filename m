Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3GQL4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:56:20 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62976 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3GQL4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:56:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130717035010.GC4541@S2101-09.ap.freescale.net>
References: <1373979376-31583-1-git-send-email-otavio@ossystems.com.br>
	<20130717035010.GC4541@S2101-09.ap.freescale.net>
Date: Wed, 17 Jul 2013 08:56:18 -0300
X-Google-Sender-Auth: xywXmCfELsossYUPsZtDdeBZcNc
Message-ID: <CAP9ODKruGc+mOs3uvNzfCgPqnXgxqTJbaPXVRDFt9TwtnwumYQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ARM: dts: imx23-evk: enable USB PHY and controller
From: Otavio Salvador <otavio@ossystems.com.br>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 12:50 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, Jul 16, 2013 at 09:56:12AM -0300, Otavio Salvador wrote:
>> The i.MX23EVK board provides a USB port so the USB PHY and controller
>> need to be enabled for it to be usable.
>>
>> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
>
> There is a typo i.XM23 in commit log of patch #2 and #3.  I fixed them
> up and applied all 3.

Thanks Shawn :)

--
Otavio Salvador                             O.S. Systems
http://www.ossystems.com.br        http://projetos.ossystems.com.br
Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750
