Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbaGCJeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:34:16 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33671 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaGCJd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:33:56 -0400
Date: Thu, 3 Jul 2014 10:33:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Add reset controllers for STiH407 SoC
Message-ID: <20140703093348.GA32208@lee--X1>
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
 <1404317194.4109.13.camel@paszta.hi.pengutronix.de>
 <20140702165924.GB17665@lee--X1>
 <53B50EFD.2070007@st.com>
 <1404379248.18039.31.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404379248.18039.31.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2014, Philipp Zabel wrote:

> Hi,
> 
> Am Donnerstag, den 03.07.2014, 10:06 +0200 schrieb Maxime Coquelin:
> > I will queue patch 4 to STi DT branch for v3.17.
> > For now, no nodes uses reset for STiH407, so we don't need the 
> > dt-bindings header file in the STi tree.
> > 
> > If we have a DT node using a reset line before my pull-request, I might 
> > have to integrate the series in the STi DT branch.
> > Philipp, does that sound reasonable?
> 
> Patch 4 depends on patch 1 for the header. My tree is still empty, how
> about I take the first two, and you merge that branch and then take 3
> and 4 on top?
> 
>     git://git.pengutronix.de/git/pza/linux.git reset/for_v3.17
> 
> Lee, shall I also add your Ack to the documentation patch?

I don't think there's anything to contentious in there:

  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
