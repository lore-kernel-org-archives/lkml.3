Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3IQIFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:05:30 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:39308 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3IQIFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:05:24 -0400
Date: Tue, 17 Sep 2013 09:05:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, arnd@arndb.de,
        linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 14/38] iio: accel: st: Append _accel to accelerator
 sensor device names
Message-ID: <20130917080517.GS16984@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-15-git-send-email-lee.jones@linaro.org>
 <52345330.4050707@kernel.org>
 <20130916133106.GI16984@lee--X1>
 <52370B08.3030709@metafoo.de>
 <5237593F.5010405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5237593F.5010405@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Jonathan Cameron wrote:

> On 09/16/13 14:43, Lars-Peter Clausen wrote:
> > On 09/16/2013 03:31 PM, Lee Jones wrote:
> >>> Honestly I don't care either way on these, but consistency would definitely
> >>> be good so applied to the togreg branch of iio.git
> >>
> >> For clarification, is togreg due for the v3.12 merge window or will be
> >> get a settling period in -next?
> >>
> > 
> > Well everything up to the 'iio-for-3.12c' tag will be in v3.12, everything
> > else not.
> > 
> > - Lars
> > 
> Yes.  At the moment IIO is routed through Greg KHs staging tree.  His merge
> window closes 1 week before Linus opens the main one (when Greg can figure
> out what Linus is intending!)  Hence I close the IIO one whenever I manage
> to get a last pull request in before that.
> 
> Hence all 3.13 for the current togreg branch.

Perfect, thanks both of you.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
