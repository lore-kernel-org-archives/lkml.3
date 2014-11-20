Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaKTNgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:36:48 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:32994 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaKTNgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:36:47 -0500
Message-ID: <546DEE66.70709@collabora.co.uk>
Date: Thu, 20 Nov 2014 14:36:38 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: cros_ec: Expose Chrome OS Lightbar to users
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk> <1416238213-15263-4-git-send-email-javier.martinez@collabora.co.uk> <20141118142242.GC24004@x1> <546DD7EA.6010108@collabora.co.uk> <20141120132733.GE13269@x1>
In-Reply-To: <20141120132733.GE13269@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 11/20/2014 02:27 PM, Lee Jones wrote:
>> > By the sounds of the description, it doesn't seem as though this
>> > driver lives in MFD.  I suggest another home, such as drivers/led.
>> > 
>> 
>> You are right. As I said in the other email, I'll move it to
>> drivers/platform/chrome/ which seems like a more suitable place.
> 
> Does it?  I would have thought 'lightbar' lives in LEDs, but I guess
> that's between you and the drivers/platform/chrome maintainer now.
> 

Ok, I'll move cros_ec_lightbar to drivers/led then and cros_ec_dev
to drivers/platform/chrome.

Thanks a lot for all your suggestions!

Best regards,
Javier
