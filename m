Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaFBNxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:53:11 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60885 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbaFBNxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:53:08 -0400
Date: Mon, 2 Jun 2014 14:53:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        chris@printf.net, ulf.hansson@linaro.org, kernel@stlinux.com,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: Add SDHCI support for STMicroelectronics SoCs
Message-ID: <20140602135302.GB4146@lee--X1>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <537E1B55.1090807@st.com>
 <20140602102930.GB437@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140602102930.GB437@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >Initially it supports the stih416 and stih415 SoCs, and has
> > >been tested on a stih416-b2020 board.
> > 
> > In next version, could you also add  drivers/mmc/host/sdhci-st.c in
> > the ARM/STI ARCHITECTURE field of MAINTAINERS file?
> 
> Was out on hols last week. I have fixed it in v2.

This should be in its own patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
