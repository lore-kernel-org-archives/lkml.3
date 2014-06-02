Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaFBK3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:29:35 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:36210 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaFBK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:29:34 -0400
Date: Mon, 2 Jun 2014 11:29:30 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        chris@printf.net, ulf.hansson@linaro.org, kernel@stlinux.com,
        lee.jones@linaro.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Add SDHCI support for STMicroelectronics SoCs
Message-ID: <20140602102930.GB437@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <537E1B55.1090807@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537E1B55.1090807@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Thu, 22 May 2014, Maxime Coquelin wrote:

> >Initially it supports the stih416 and stih415 SoCs, and has
> >been tested on a stih416-b2020 board.
> 
> In next version, could you also add  drivers/mmc/host/sdhci-st.c in
> the ARM/STI ARCHITECTURE field of MAINTAINERS file?

Was out on hols last week. I have fixed it in v2.

Cheers,

Peter

