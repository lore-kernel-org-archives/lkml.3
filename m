Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaKTN2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:28:09 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38463 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbaKTN1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:27:40 -0500
Date: Thu, 20 Nov 2014 13:27:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: cros_ec: Expose Chrome OS Lightbar to users
Message-ID: <20141120132733.GE13269@x1>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
 <1416238213-15263-4-git-send-email-javier.martinez@collabora.co.uk>
 <20141118142242.GC24004@x1>
 <546DD7EA.6010108@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546DD7EA.6010108@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Javier Martinez Canillas wrote:

> Hello Lee,
> 
> On 11/18/2014 03:22 PM, Lee Jones wrote:
> >> ---
> >>  drivers/mfd/Makefile           |   2 +-
> >>  drivers/mfd/cros_ec_dev.c      |   2 +
> >>  drivers/mfd/cros_ec_dev.h      |   3 +
> >>  drivers/mfd/cros_ec_lightbar.c | 347 +++++++++++++++++++++++++++++++++++++++++
> > 
> > By the sounds of the description, it doesn't seem as though this
> > driver lives in MFD.  I suggest another home, such as drivers/led.
> > 
> 
> You are right. As I said in the other email, I'll move it to
> drivers/platform/chrome/ which seems like a more suitable place.

Does it?  I would have thought 'lightbar' lives in LEDs, but I guess
that's between you and the drivers/platform/chrome maintainer now.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
