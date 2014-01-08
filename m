Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaAHJ1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:27:39 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34114 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaAHJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:27:36 -0500
Date: Wed, 8 Jan 2014 09:27:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, robh+dt@kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 1/3] mfd: Add support for S2MPA01 device
Message-ID: <20140108092731.GF19974@lee--X1>
References: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
 <20140108090208.GD19974@lee--X1>
 <CAK9yfHyDNfRcn4J6N5u=CbVHsRqCp5LSgUavsD1p7Gjp+m9dfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9yfHyDNfRcn4J6N5u=CbVHsRqCp5LSgUavsD1p7Gjp+m9dfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> @@ -92,7 +93,7 @@ struct sec_platform_data {
> >>       int                             buck3_default_idx;
> >>       int                             buck4_default_idx;
> >>
> >> -     int                             buck_ramp_delay;
> >> +     int                             buck_ramp_delay;
> >
> > What's this? Are you fixing (or breaking) white space here?
> 
> I didn't get you. I have converted spaces to tabs here. See some problem?

No problem. It was unclear in the patch, as white space changes do not
show up in my mail client.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
