Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbaLKMrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:47:39 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33921 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629AbaLKMrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:47:36 -0500
Message-ID: <54899264.30009@cogentembedded.com>
Date: Thu, 11 Dec 2014 15:47:32 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        myungjoo.ham@samsung.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] extcon: add MAX3355 driver
References: <14631865.01KLlU2iKL@wasted.cogentembedded.com> <5488F775.1030304@samsung.com>
In-Reply-To: <5488F775.1030304@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/11/2014 4:46 AM, Chanwoo Choi wrote:

> I reviewed this patch quickly. This driver has just two gpio without any registers for IP.

    Because there are no registers.

> I wonder whether MAX3355E is separate chip to detect external connector

    Yes. I thought my description has made that clear...

> or just use gpio of AP.

    What do you mean by AP?
    MAX3355 is indeed partly connected to GPIOs and partly to the USB pins.

> Could you send the datasheet of MAX3355E to me?

    Looks like Geert has beaten me to it. :-)

> Thanks,
> Chanwoo Choi

WBR, Sergei

