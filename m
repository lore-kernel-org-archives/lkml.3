Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3A1IpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:45:10 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35976 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3A1IpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:45:08 -0500
Date: Mon, 28 Jan 2013 08:45:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 25/26] mfd: ab8500-gpadc: Reduce conversion timeout
Message-ID: <20130128084503.GC15873@gmail.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-26-git-send-email-lee.jones@linaro.org>
 <20130127235339.GS1174@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130127235339.GS1174@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Samuel Ortiz wrote:

> Hi Lee,
> 
> On Tue, Jan 15, 2013 at 12:56:05PM +0000, Lee Jones wrote:
> > @@ -598,8 +601,6 @@ static int ab8500_gpadc_runtime_resume(struct device *dev)
> >  
> >  static int ab8500_gpadc_runtime_idle(struct device *dev)
> >  {
> > -	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> > -
> Unrelated change, please remove that part.

I'll fixup.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
