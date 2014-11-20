Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbaKTN0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:26:31 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60105 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336AbaKTN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:26:07 -0500
Date: Thu, 20 Nov 2014 13:26:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device
 interface
Message-ID: <20141120132600.GD13269@x1>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
 <1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk>
 <20141118141827.GB24004@x1>
 <546DD00E.4000704@collabora.co.uk>
 <20141120115817.GC13269@x1>
 <546DDAE9.7010602@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546DDAE9.7010602@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I know how the device driver model works.  I'm asking where the
> > 'device' is registered from, not the 'driver' i.e. platform data, DT,
> > ACPI?
> > 
> 
> Right, sorry for misunderstanding your question and the silly comment then.
> 
> $Subject adds a "cros-ec-dev" mfd cell to the cros ec mfd driver.
> So the device is registered from DT when the cros ec device node is
> matched (e.g: "google,cros-ec-spi" or "google,cros-ec-i2c") and the
> cros ec mfd driver probe function calls mfd_add_devices().

Ah, so it's registered from another MFD device.  That's okay then.
That answers my question.  FWIW I was going to ask about the missing
match table, but that's not required in this case.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
