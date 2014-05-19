Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaESJar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:30:47 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:48102 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaESJap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:30:45 -0400
Date: Mon, 19 May 2014 10:30:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pankaj Dev <pankaj.dev@st.com>
Subject: Re: [PATCH 1/9] ARM: STi: DT: STiH416: 416 DT Entry for clockgen
 A0/1/10/11/12
Message-ID: <20140519093038.GF4978@lee--X1>
References: <1399305223-18703-1-git-send-email-gabriel.fernandez@linaro.org>
 <1399305223-18703-2-git-send-email-gabriel.fernandez@linaro.org>
 <20140506071843.GD5206@lee--X1>
 <CAG374jD+msPPbPtFS+ji=8jS9+D-YHu31k7zzzC7Ty7jw9n7jQ@mail.gmail.com>
 <20140508080344.GE5307@lee--X1>
 <5373586A.5000302@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5373586A.5000302@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Maxime Coquelin wrote:

> Hi Lee,
> 
> On 05/08/2014 10:03 AM, Lee Jones wrote:
> >>>>Patch adds DT entries for clockgen A0/1/10/11/12
> >>>>
> >>>>Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
> >>>>Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> >>>>---
> >>>>  arch/arm/boot/dts/stih416-clks.h     |  15 ++
> >>>
> >>>This should live in include/dt-bindings/clk
> >>>
> >>include/dt-bindings/clk or  include/dt-bindings/clock ?
> >
> >I have no idea what the difference between the two are.  I guess you
> >are in a better position to answer that.  My point was just that the
> >includes should be in the include directory, rather than being held
> >locally in the 'dts' directory.
> 
> Even if these .h files are only used by the DTS files??
> 
> There are some .h files for pincfg related stuff, shouldn't we do
> the same in this case?

I believe so.  There are a few include files which are only referenced
from DTS(I) files.  I would be cautious about needlessly overloading
arch/arm/boot/dts with files which do not need to be there.  This is
my personal opinion though, perhaps the DT guys have other ideas.

> >>>>  arch/arm/boot/dts/stih416-clock.dtsi | 477 ++++++++++++++++++++++++++++++++++
> >>>>  arch/arm/boot/dts/stih416.dtsi       |  10 +-
> >>>>  3 files changed, 497 insertions(+), 5 deletions(-)
> >>>>  create mode 100644 arch/arm/boot/dts/stih416-clks.h
> >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
