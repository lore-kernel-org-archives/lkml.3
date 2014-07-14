Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaGNNIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:08:40 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:43808 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbaGNNIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:08:31 -0400
Date: Mon, 14 Jul 2014 14:08:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, ajitpal.singh@st.com, edubezval@gmail.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Subject: Re: [RESEND PATCH 0/6] thermal: sti: Add new Thermal driver
Message-ID: <20140714130824.GA3993@lee--X1>
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
 <20140624092309.GD13803@lee--X1>
 <20140709120823.GA32573@lee--X1>
 <1404911964.28592.4.camel@rzhang1-toshiba>
 <20140709134646.GB479@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140709134646.GB479@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2014, Lee Jones wrote:
> On Wed, 09 Jul 2014, Zhang Rui wrote:
> > On Wed, 2014-07-09 at 13:08 +0100, Lee Jones wrote:
> > > On Tue, 24 Jun 2014, Lee Jones wrote:
> > > 
> > > > > I'm re-sending this set, as one of the maintainers' email addresses
> > > > > is incorrect in the MAINTAINERS file.
> > > > > 
> > > > > This patchset adds full support for 2 types of Thermal Controllers
> > > > > produced by STMicroelectronics.  One is a more traditional memory
> > > > > mapped variant, the other is controlled solely by system configuration
> > > > > registers.
> > > > 
> > > > Any thing from the Thermal guys? Has this set fallen through the gaps?
> > > 
> > > Anything at all?  It's been well over a month now.
> > > 
> > Well, for the soc thermal drivers, I'd prefer to take them via Eduardo,
> > but as we didn't get any feedback from Eduardo, I will take them.
> 
> Thanks Rui.
> 
> So have you taken all 4 "thermal: sti: *" patches?

Have you taken these yet?  I notice that these aren't in -next yet.

> The ARM ones should go through Maxime.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
