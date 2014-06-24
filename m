Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaFXOTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:19:21 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:46141 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaFXOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:19:20 -0400
Date: Tue, 24 Jun 2014 15:19:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Alan, can you revisit a patch you authored please?
Message-ID: <20140624141914.GP13803@lee--X1>
References: <20140623085345.GD8847@lee--X1>
 <20140624133611.62e4c3b7@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140624133611.62e4c3b7@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, One Thousand Gnomes wrote:
> On Mon, 23 Jun 2014 09:53:45 +0100
> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Hi Alan,
> > 
> > I'm looking at a patch you wrote which can be foudn below at [1].  Are
> > you sure it's correct to ignore i.e not return -ENOMEM from
> > platform_device_add_data() in pcf50633_probe()?  I believe if
> > platform_device_add_data() returns an error we should
> > platform_device_put() and return immediately.  Can you tell me if you
> > agree.  If you don't, would you mind explaining to me why please?
> 
> I made the change to maximise the chance of things booting up ok, but I
> agree, its a pointless exercise. If we fail to add the data we should
> just chuck it.

Thanks Alan, I'll get a patch out shortly.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
