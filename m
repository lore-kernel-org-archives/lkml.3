Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaCKNfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:35:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60708 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaCKNfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:35:48 -0400
Date: Tue, 11 Mar 2014 13:35:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Trilok Soni <tsoni@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Anirudh Ghayal <aghayal@codeaurora.org>, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Qualcomm PMIC8xxx keypad never worked?
Message-ID: <20140311133542.GO21216@lee--X1>
References: <5887114.1jrNo21sGX@wuerfel>
 <20140311120056.GH21216@lee--X1>
 <8206209.oc1V5pPVYT@wuerfel>
 <20140311130609.GL21216@lee--X1>
 <20140311132013.GO18529@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140311132013.GO18529@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > Something in the MFD_PM8XXX driver must have changed recently that now allows
> > > > > the KEYBOARD_PMIC8XXX driver to be enabled. Unfortunately, it does not build
> > > > > because of a dependency on the <linux/mfd/pm8xxx/gpio.h> header file that
> > > > > does not exist.
> > 
> > I think it's this commit that's causing your error:
> > 
> >   https://lkml.org/lkml/2013/12/10/903
> > 
> > ... but the MFD isn't broken, so I guess your solution is the most
> > elegant. If it's not fixed soon, I guess we should think about ripping
> > it out. It's obvoious that no-one cares, as it's been broken for
> > nearly 3 years.
> 
> Stephen has a pending patchset to cleanup and actually make the pm8xxx
> input drivers work, but they have not been picked up yet:
> 
> http://lkml.kernel.org/r/1393958088-1456-1-git-send-email-sboyd@codeaurora.org

Ideal. Thanks for letting us know.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
