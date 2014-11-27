Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaK0Ioz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:44:55 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:48919 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbaK0Iox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:44:53 -0500
Date: Thu, 27 Nov 2014 08:44:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        arnd Bergmann <arnd@arndb.de>, olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] MAINTAINERS: Add ahci_st.c to ARCH/STI architecture
Message-ID: <20141127084447.GB4628@x1>
References: <1416386694-7402-1-git-send-email-peter.griffin@linaro.org>
 <5475DA1C.50307@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5475DA1C.50307@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Maxime Coquelin wrote:

> Hi Peter,
> 
> On 11/19/2014 09:44 AM, Peter Griffin wrote:
> >This patch adds the ahci_st.c driver found on STMicroelectronics
> >stih41x consumer electronics SoC's into the STI arch section
> >of the maintainers file.
> >
> >Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
> 
> Arnd, Olof, could you pick this one directly?
> I only have this single patch remaining for v3.19, so didn't planned
> to send another pull-request.

Better to send to (or at least Cc) arm@kernel.org.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
