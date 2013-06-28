Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3F1NZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:25:58 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:59025 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3F1NZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130628073013.GJ27010@pengutronix.de>
References: <1372390325-7566-1-git-send-email-festevam@gmail.com>
	<1372390325-7566-5-git-send-email-festevam@gmail.com>
	<20130628073013.GJ27010@pengutronix.de>
Date: Fri, 28 Jun 2013 10:25:56 -0300
Message-ID: <CAOMZO5Be=dn3n1_-Gt=urTUo=Jg1cxVREO_hPHS-VhGiQzovzg@mail.gmail.com>
Subject: Re: [PATCH 5/5] imx-drm: ipu-dp: Adjust the maximum number of flows
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: gregkh@linuxfoundation.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Fri, Jun 28, 2013 at 4:30 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Fri, Jun 28, 2013 at 12:32:05AM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Later in ipu_dp_get() the index of the flow array is calculated by:
>> flow >> 1
>>
>> So adjust its maximum to IPUV3_NUM_FLOWS << 1.
> Maybe squash this into patch 4?

Patch 4 is just cosmetic, but in this one I am changing the comparison from:
'if (flow > 5)' to 'if (flow > 6)'

,so that's why I splitted them.

I am OK with squashing the two patches together though.

Sascha,

Do you agree with the 'if (flow > 6)' change?

Thanks,

Fabio Estevam
