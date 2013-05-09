Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3EIA60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 20:58:26 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:37654 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3EIA6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 20:58:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130508153740.GB17186@kroah.com>
References: <alpine.DEB.2.02.1305081846070.29540@M2420>
	<20130508153740.GB17186@kroah.com>
Date: Thu, 9 May 2013 08:58:20 +0800
Message-ID: <CADJHv_tp637J2D8-JOteF6UOnCAEJTXG1JGAzY9EDsTCCfoRRg@mail.gmail.com>
Subject: Re: [PATCH] staging: android: logger: use kuid_t instead of uid_t
From: Xiong Zhou <jencce.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, john.stultz@linaro.org,
        kernel-team@android.com, nnk@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks all for reviewing.

xiong

2013/5/8 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, May 08, 2013 at 06:52:48PM +0800, Xiong Zhou wrote:
>> From: Xiong Zhou <jencce.kernel@gmail.com>
>>
>> Use kuid_t instead of uid_t, to pass the UIDGID_STRICT_TYPE_CHECKS.
>>
>> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
>
> Nice job, I'll queue this up after 3.10-rc1 is out.
>
> greg k-h
