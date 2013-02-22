Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab3BVR2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:28:06 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62095 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab3BVR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:28:01 -0500
Message-ID: <5127AA9E.9030008@linaro.org>
Date: Fri, 22 Feb 2013 09:27:58 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: Origen board hang with functionfs
References: <51257FFF.3070109@linaro.org> <51266897.9070308@linaro.org> <51271673.9090003@linaro.org>
In-Reply-To: <51271673.9090003@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 10:55 PM, Tushar Behera wrote:
>
> I think the issue is because of the USB phy regulators. LDO3 and LDO8
> power the phy regulators for OTG and HOST. These regulators are disabled
> in OTG probe whereas they are not handled at all in HOST driver. Keeping
> these LDOs always active should solve the problem for the time being.
>
> I will follow-up with a patch shortly. But I am not sure if this patch
> will be considered for mainline as board patches are not getting
> accepted these days.

So your patch worked great for me! Thanks for the analysis and the patch!

In the above, do you mean board-patches aren't getting accepted since 
the 3.9 merge window is already open, or that folks aren't accepting 
board patches at all?

thanks
-john

