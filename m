Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab3DDKPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:15:43 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45231 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab3DDKPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:15:41 -0400
Date: Thu, 4 Apr 2013 11:15:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 9/9] mfd: db8500-prcmu: Support platform dependant device
 selection
Message-ID: <20130404101536.GC8921@gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
 <1364908916-29803-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdaRfBFMO+XnJVq9ccxsqw3+RS+OCPuF8ivrrRu=OxuJEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaRfBFMO+XnJVq9ccxsqw3+RS+OCPuF8ivrrRu=OxuJEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Apr 2013, Linus Walleij wrote:

> On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The main aim for this cycle is to have the u8540 booting to a
> > console. However, the u8540 doesn't support all of the u8500
> > platform devices yet. After this stage is complete we can then
> > fill in the inadequacies, such as specific clock support at a
> > later date. To achieve this we're placing devices supported by
> > all platforms into a common device structure and the remaining
> > ones into a platform specific one.
> >
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> This should also go through the MFD tree.

Right. I'll add your Ack and resubmit.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
