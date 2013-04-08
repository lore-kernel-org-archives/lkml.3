Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114Ab3DHIfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:35:39 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47977 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934430Ab3DHIfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:35:37 -0400
MIME-Version: 1.0
In-Reply-To: <544AC56F16B56944AEC3BD4E3D591771602C593BF8@LIMKCMBX1.ad.analog.com>
References: <1363347628-15344-1-git-send-email-sachin.kamat@linaro.org>
	<CAK9yfHyw+rfgpBW+JiGE4bgv3s5t3nmGxoeqzE-ystq_b+mf8A@mail.gmail.com>
	<544AC56F16B56944AEC3BD4E3D591771602C593BF8@LIMKCMBX1.ad.analog.com>
Date: Mon, 8 Apr 2013 14:05:37 +0530
Message-ID: <CAK9yfHzcRED3jiVRfkMpEPzKmYyS7dw+Lx+vOekG4o4nbc_KUw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: adp5520: Use module_i2c_driver()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: sameo@linux.intel.com
Cc: "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2013 14:50, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
>
> ________________________________________
> Von: Sachin Kamat [sachin.kamat@linaro.org]
> Gesendet: Mittwoch, 27. März 2013 09:59
> An: device-drivers-devel@blackfin.uclinux.org; LKML
> Cc: Hennerich, Michael; sameo@linux.intel.com; sachin.kamat@linaro.org
> Betreff: Re: [PATCH 1/1] mfd: adp5520: Use module_i2c_driver()
>
> On 15 March 2013 17:10, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> module_i2c_driver() removes some boilerplate and makes the code
>> simple.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>
>

Ping Samuel.

-- 
With warm regards,
Sachin
