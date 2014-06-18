Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966096AbaFRKuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:50:13 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:41749 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966050AbaFRKuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:50:08 -0400
Date: Wed, 18 Jun 2014 11:50:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: stih41x: Rename stih416-b2020-revE.dts to
 stih416-b2020e.dts
Message-ID: <20140618105001.GB8300@lee--X1>
References: <1403087508-6710-1-git-send-email-lee.jones@linaro.org>
 <CALNtEFic8xNRsx2jSj6z7Zw7YL2U+1gJ=THNw6t_LM5u8Y5o7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALNtEFic8xNRsx2jSj6z7Zw7YL2U+1gJ=THNw6t_LM5u8Y5o7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Srinivas Kandagatla wrote:

> Shouldn’t you do the same in Makefile?

Ah balls!  That's what happens when you rush.

Respinning.

> On Wed, Jun 18, 2014 at 11:31 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Two reasons for this rename.  Firstly, it removes the camel case
> > convention which isn't used by any other platform and secondly it
> > matches the naming convention for the internal kernel, which can
> > become annoying when flipping between the two.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} | 0
> >  1 file changed, 0 insertions(+), 0 deletions(-)
> >  rename arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts}
> > (100%)
> >
> > diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts
> > b/arch/arm/boot/dts/stih416-b2020e.dts
> > similarity index 100%
> > rename from arch/arm/boot/dts/stih416-b2020-revE.dts
> > rename to arch/arm/boot/dts/stih416-b2020e.dts
> >
> >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
