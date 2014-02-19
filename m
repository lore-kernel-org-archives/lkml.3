Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaBSVsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:48:46 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:57475 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaBSVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:48:44 -0500
MIME-Version: 1.0
In-Reply-To: <CANLzEkv6YiY40QnSao7p=17SsZsnCPHT6zOMYNGCpbsa5d_OcA@mail.gmail.com>
References: <1389064083-11018-1-git-send-email-dusonlin@emc.com.tw>
	<CANLzEksP3nT2=GUu8sAA95ikNbyA0KD_s4qVGhno2MHYp7_1YQ@mail.gmail.com>
	<CANLzEkv6YiY40QnSao7p=17SsZsnCPHT6zOMYNGCpbsa5d_OcA@mail.gmail.com>
Date: Wed, 19 Feb 2014 13:48:43 -0800
X-Google-Sender-Auth: 2vFXFymo0tt7RMOYg3jZHLxY0Ko
Message-ID: <CANLzEktjRPs_yogpQb9Z90ksUxttPMVgdKGtJAv7Q1_qC_4Lsg@mail.gmail.com>
Subject: Re: [PATCH v2] Input: add i2c/smbus driver for elan touchpad
From: Benson Leung <bleung@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, agnescheng@chromium.org,
        phoenix@emc.com.tw, "Jeff.Chuang" <jeff.chuang@emc.com.tw>,
        Duson Lin <dusonlin@emc.com.tw>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 4:21 PM, Benson Leung <bleung@chromium.org> wrote:
> On Fri, Jan 10, 2014 at 12:30 PM, Benson Leung <bleung@chromium.org> wrote:
>> On Mon, Jan 6, 2014 at 7:08 PM, Duson Lin <dusonlin@emc.com.tw> wrote:
>>> This driver adds support for elan i2c/smbus touchpad found on some laptops PC
>>>
>>> Signed-off-by: Duson Lin <dusonlin@emc.com.tw>
>>
>> Reviewed-by: Benson Leung <bleung@chromium.org>
>>
>
> Hi Dmitry, This should be the most up to date version of this driver.
> Disregard the one I pinged from Dec 17, 2013 . Could you take another
> look at this?

Hi Dmitry,

Could you help take a look at Duson's latest elan_i2c driver submission?

Reviewed-by: Benson Leung <bleung@chromium.org>

Thanks,


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
