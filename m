Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3KRPb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:31:29 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:37685 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3KRPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:31:20 -0500
Date: Mon, 18 Nov 2013 15:31:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com
Subject: Re: [PATCH 02/10] mtd: st_spi_fsm: Supply all register address and
 bit logic defines
Message-ID: <20131118153110.GN13640@lee--X1>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
 <1384438956-31153-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaccxcTfKc-y7rPEH1H3yua3ubLvuvTzWnMs1rOwjiVNw@mail.gmail.com>
 <20131118093229.GB13640@lee--X1>
 <20131118133940.GC14306@sirena.org.uk>
 <20131118142447.GJ13640@lee--X1>
 <20131118144512.GB24408@sirena.org.uk>
 <20131118145614.GM13640@lee--X1>
 <20131118151651.GE24408@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131118151651.GE24408@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Mark Brown wrote:

> On Mon, Nov 18, 2013 at 02:56:14PM +0000, Lee Jones wrote:
> 
> > I think it's a good idea for people using the m25p80, but still
> > doesn't effect us. All of our chips are dynamically probable. We are
> 
> This doesn't seem realistic, you're assuming that system integrators
> won't go and use chips you've not heard of and at least in the case of
> things like quad read my understanding is that the commands aren't
> standardised so the host just has to know what to write.

I'm not following? What are you suggesting?

After some analysis we have come to the conclusion that using m25p80
is not feasible. It makes more sense for this to be an
orthogonal/stand-alone driver.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
