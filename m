Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaBKRso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:48:44 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38624 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaBKRsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:48:36 -0500
Date: Tue, 11 Feb 2014 17:48:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 08/12] mfd: vexpress-sysreg: Add syscon labels as
 platform data
Message-ID: <20140211174829.GJ15081@lee--X1>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
 <1392138636-29240-9-git-send-email-pawel.moll@arm.com>
 <20140211172918.GH15081@lee--X1>
 <1392139946.3380.48.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392139946.3380.48.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Pawel Moll wrote:

> On Tue, 2014-02-11 at 17:29 +0000, Lee Jones wrote:
> > There must be better
> > ways of passing a name than through pdata, and if there isn't I'd
> > suggest setting up a sysconf pdata struct that others can use in case
> > they wish to expand the functionality further in some other
> > unfathomable way. :)
> 
> ... which I proposed in the previous patch :-)
> 
> > Alternatively I could define a syscon platform data structure,
> > something like this:
> > 
> > struct syscon_platform_data {
> > 	const char *label;
> > };

So you did.

Yes, this would be the lesser of the two evils. 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
