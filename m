Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3FDJ5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:57:09 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:33304 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3FDJ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:57:06 -0400
Date: Tue, 4 Jun 2013 11:56:57 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/5] ARM: ux500: Provide auxdata to ux500 ASoC driver
Message-ID: <20130604095657.GA9581@balto.lan>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
 <1369920465-13905-5-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkda8h_zewd2M7QzvoLn15iDEUv8XYCGqro62chiCcYaM8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda8h_zewd2M7QzvoLn15iDEUv8XYCGqro62chiCcYaM8Q@mail.gmail.com>
X-Operating-System: Linux balto 3.10.0-rc2-00332-g17fdfd0 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 11:03:41AM +0200, Linus Walleij wrote:
> On Thu, May 30, 2013 at 3:27 PM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> 
> > Ux500 ASoC driver is expected to have a specific device name to get
> > clock resources correctly.  This patch provides the necessary
> > OF_DEV_AUXDATA to match the name in DT and non-DT cases.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> Patch applied to my ux500-devicetree branch after some rebasing.

Thanks!  I saw that a lot patches are stacking up in the tree, do you
plan to send an intermediate pull request to get these on
arm-soc/for-next (and linux-next)?

Thanks,
Fabio

> 
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Fabio Baltieri
