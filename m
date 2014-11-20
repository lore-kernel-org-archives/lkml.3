Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbaKTMAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:00:50 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:32894 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaKTMAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:00:49 -0500
Message-ID: <546DD7EA.6010108@collabora.co.uk>
Date: Thu, 20 Nov 2014 13:00:42 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: cros_ec: Expose Chrome OS Lightbar to users
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk> <1416238213-15263-4-git-send-email-javier.martinez@collabora.co.uk> <20141118142242.GC24004@x1>
In-Reply-To: <20141118142242.GC24004@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 11/18/2014 03:22 PM, Lee Jones wrote:
>> ---
>>  drivers/mfd/Makefile           |   2 +-
>>  drivers/mfd/cros_ec_dev.c      |   2 +
>>  drivers/mfd/cros_ec_dev.h      |   3 +
>>  drivers/mfd/cros_ec_lightbar.c | 347 +++++++++++++++++++++++++++++++++++++++++
> 
> By the sounds of the description, it doesn't seem as though this
> driver lives in MFD.  I suggest another home, such as drivers/led.
> 

You are right. As I said in the other email, I'll move it to
drivers/platform/chrome/ which seems like a more suitable place.

Thanks a lot for your feedback.

Best regards,
Javier
