Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaDWKzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:55:49 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53010 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaDWKzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:55:46 -0400
Date: Wed, 23 Apr 2014 11:55:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>, Anton Vorontsov <anton@enomsg.org>,
        olof@lixom.net, Sachin Kamat <sachin.kamat@linaro.org>,
        ajaykumar.rs@samsung.com, linux-samsung-soc@vger.kernel.org,
        sameo@linux.intel.com, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v3 3/5] mfd: tps65090: Stop caching most registers
Message-ID: <20140423105540.GJ21613@lee--X1>
References: <1398180298-2018-4-git-send-email-dianders@chromium.org>
 <20140422190754.GF12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140422190754.GF12304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Nearly all of the registers in tps65090 combine control bits and
> > status bits.  Turn off caching of all registers except the select few
> > that can be cached.
> 
> Lee, I don't mind if I apply this and send a pull request to you or I
> pull a tag from you with this in - what's easiest for you?

I'm happy to do it.

Doug,
  Can you send the patch-set again with all of the *-bys and ensure
  I'm on TO or CC please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
