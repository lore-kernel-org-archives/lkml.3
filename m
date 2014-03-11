Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaCKLRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:17:18 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:45258 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaCKLRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:17:17 -0400
Date: Tue, 11 Mar 2014 11:17:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com
Subject: Re: [PATCH 2/3] ARM: STi: stih416-b2020: Explicitly include STiH416
 Pinctrl bindings
Message-ID: <20140311111711.GC21216@lee--X1>
References: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
 <1394533324-20299-2-git-send-email-lee.jones@linaro.org>
 <531EEADF.5060001@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531EEADF.5060001@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  #include "stih41x-b2020.dtsi"
> >  / {
> >          model = "STih416 B2020 REV. E";
> >
> 
> For the next revision, could you please add kernel@stlinux.com in cc?

Ah yes, of course. My mistake. I used the wrong flag when sending the
patches '--arm' instaed of '--st-arm'. 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
