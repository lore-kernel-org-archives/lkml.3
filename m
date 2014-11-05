Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaKEP14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:27:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42577 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbaKEP1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:27:52 -0500
Message-ID: <545A415D.1070002@ti.com>
Date: Wed, 5 Nov 2014 20:55:17 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>
Subject: Re: [PATCH 0/4] extcon: gpio: add DT support
References: <1415032350-8459-1-git-send-email-balbi@ti.com> <54586E34.6090602@ti.com> <20141104144116.GB24983@saruman>
In-Reply-To: <20141104144116.GB24983@saruman>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/04/2014 08:11 PM, Felipe Balbi wrote:
> On Tue, Nov 04, 2014 at 11:42:04AM +0530, George Cherian wrote:
>> Hi Felipe et al.
>>
>> Another series was posted by removing the platform support.
>> https://lkml.org/lkml/2014/10/14/244
>>
>> I guess I forgot to copy linux-omap.
> you do too many things in patch one. I wonder why you decided to combine
> three patches in one for that series.
Since there are no platform users for this driver. I am basically 
removing the whole platform data part
from the driver. That is the reason i squashed 1 to 3 of the previous 
series.
I will resend the new series copying linux-omap now.

