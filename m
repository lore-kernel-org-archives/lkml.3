Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaFFXUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:20:04 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:46693 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaFFXUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:20:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140606223123.10062.29366@quantum>
References: <1401467562-5585-1-git-send-email-dianders@chromium.org>
	<1402000514-30752-1-git-send-email-dianders@chromium.org>
	<20140606000324.10062.10257@quantum>
	<CAD=FV=UQhBh68Bgv=kfUROCOxg1dS1OnZ1ir+wouewKoDFE_1g@mail.gmail.com>
	<20140606223123.10062.29366@quantum>
Date: Fri, 6 Jun 2014 16:19:59 -0700
X-Google-Sender-Auth: id88Gj0ueUu0P5_nTPU4-Qth3EY
Message-ID: <CAD=FV=Wug+3yanjUJ6OffHggJnKEcWcAKKovtEbswoFDmhevmQ@mail.gmail.com>
Subject: Re: [PATCH v3] clk: exynos5420: Remove aclk66_peric from the clock
 tree description
From: Doug Anderson <dianders@chromium.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Arun Kumar <arun.kk@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, a.hajda@samsung.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On Fri, Jun 6, 2014 at 3:31 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Anyways, getting back on point, Tomasz was right about the whole clk_get
> thing. So I'm happy to take either V1 or V3 of your patch. I will be
> submitting a second PR for 3.16 next week and it will include whichever
> version you and Tomasz agree is best.

I like V3 slightly better and it has Tomasz's Ack.  Unless he emails
and suggests that he really V1 better then I'd say go with V3.  If we
go back to V1 we'll need to add the "return 0", which I'm happy to do.

Thanks!

-Doug
