Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3CRJsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:48:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36619 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab3CRJsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:48:05 -0400
Message-ID: <5146E2CA.8000109@ti.com>
Date: Mon, 18 Mar 2013 15:17:54 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] ARM: davinci: dm365: add support for v4l2 video
 display
References: <1363360303-15521-1-git-send-email-prabhakar.csengg@gmail.com> <1363360303-15521-2-git-send-email-prabhakar.csengg@gmail.com> <5146CDC5.9000702@ti.com> <CA+V-a8umwxKFHjSQ=yDwfp8VWTQyn0dyp-=ESSUvRPXawt01Jg@mail.gmail.com>
In-Reply-To: <CA+V-a8umwxKFHjSQ=yDwfp8VWTQyn0dyp-=ESSUvRPXawt01Jg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/18/2013 2:46 PM, Prabhakar Lad wrote:
> On Mon, Mar 18, 2013 at 1:48 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 3/15/2013 8:41 PM, Prabhakar lad wrote:

>>> +int __init dm365_init_video(struct vpfe_config *vpfe_cfg,
>>> +                             struct vpbe_config *vpbe_cfg)
>>> +{
>>> +     if (vpfe_cfg || vpbe_cfg)
>>> +             platform_device_register(&dm365_vpss_device);
>>> +
>>> +     if (vpfe_cfg) {
>>> +             vpfe_capture_dev.dev.platform_data = vpfe_cfg;
>>> +             /* Add isif clock alias */
>>
>> This comment is useless. Instead please document why the aliases are
>> needed. I know you are just moving code here, but lets do a clean-up job
>> while at it.
>>
> by document you mean to add a file in Documentation folder ?

No, just modify the comment to talk about why the aliases are needed.

Thanks,
Sekhar
