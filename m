Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaHKN4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:56:54 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:59159 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaHKN4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:56:52 -0400
Date: Mon, 11 Aug 2014 14:56:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, ajitpal.singh@st.com, edubezval@gmail.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Subject: Re: [RESEND PATCH 0/6] thermal: sti: Add new Thermal driver
Message-ID: <20140811135645.GD31769@lee--X1>
References: <20140624092309.GD13803@lee--X1>
 <20140709120823.GA32573@lee--X1>
 <1404911964.28592.4.camel@rzhang1-toshiba>
 <20140709134646.GB479@lee--X1>
 <20140714130824.GA3993@lee--X1>
 <1405347277.28592.25.camel@rzhang1-toshiba>
 <20140714142703.GC3993@lee--X1>
 <20140721091753.GV30888@lee--X1>
 <1405935299.2455.3.camel@rzhang1-toshiba>
 <20140721101306.GW30888@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140721101306.GW30888@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Lee Jones wrote:
> On Mon, 21 Jul 2014, Zhang Rui wrote:
> > On Mon, 2014-07-21 at 10:17 +0100, Lee Jones wrote:
> > > On Mon, 14 Jul 2014, Lee Jones wrote:
> > > > On Mon, 14 Jul 2014, Zhang Rui wrote:
> > > > > On Mon, 2014-07-14 at 14:08 +0100, Lee Jones wrote:
> > > > > > On Wed, 09 Jul 2014, Lee Jones wrote:
> > > > > > > On Wed, 09 Jul 2014, Zhang Rui wrote:
> > > > > > > > On Wed, 2014-07-09 at 13:08 +0100, Lee Jones wrote:
> > > > > > > > > On Tue, 24 Jun 2014, Lee Jones wrote:
> > > > > > > > > 
> > > > > > > > > > > I'm re-sending this set, as one of the maintainers' email addresses
> > > > > > > > > > > is incorrect in the MAINTAINERS file.
> > > > > > > > > > > 
> > > > > > > > > > > This patchset adds full support for 2 types of Thermal Controllers
> > > > > > > > > > > produced by STMicroelectronics.  One is a more traditional memory
> > > > > > > > > > > mapped variant, the other is controlled solely by system configuration
> > > > > > > > > > > registers.
> > > > > > > > > > 
> > > > > > > > > > Any thing from the Thermal guys? Has this set fallen through the gaps?
> > > > > > > > > 
> > > > > > > > > Anything at all?  It's been well over a month now.
> > > > > > > > > 
> > > > > > > > Well, for the soc thermal drivers, I'd prefer to take them via Eduardo,
> > > > > > > > but as we didn't get any feedback from Eduardo, I will take them.
> > > > > > > 
> > > > > > > Thanks Rui.
> > > > > > > 
> > > > > > > So have you taken all 4 "thermal: sti: *" patches?
> > > > > > 
> > > > > > Have you taken these yet?
> > > > > 
> > > > > Not yet. will do tomorrow.
> > > 
> > > I waited 7 days and still don't see them?
> > > 
> > Done, they're in my local tree and I forgot to push them.
> > thanks for the reminder.
> 
> Thanks dude.

Hi Rui,

Do you know when you will send your pull-request?

We are half way through the merge window and I don't see any new
Thermal patches?

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
