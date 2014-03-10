Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaCJIy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:54:58 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53751 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaCJIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:54:56 -0400
Date: Mon, 10 Mar 2014 08:54:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Fix cs5535 dependencies
Message-ID: <20140310085451.GC14976@lee--X1>
References: <20140307220051.0b004abf@endymion.delvare>
 <20140307212545.6c1dab79@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140307212545.6c1dab79@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jean Delvare <jdelvare@suse.de> wrote:
> 
> > As far as I know, the CS5535 and CS5536 chipsets are companions of the
> > Geode series of processors, which are 32-bit only. So the CS5535
> > drivers are not needed on x86-64, except for build testing purpose.
> > 
> > This aligns the dependencies to what FB_GEODE already uses.
> > 
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> 
> This looks correct to me. Also true for the ATA driver and a few others
> plus for the CS5510 and 5520.

Is that an Ack Alan?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
