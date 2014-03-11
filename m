Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaCKLXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:23:50 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45997 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaCKLXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:23:48 -0400
Date: Tue, 11 Mar 2014 11:23:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com
Subject: Re: [PATCH 1/3] ARM: DT: STi: Add support to B2020 revision E board.
Message-ID: <20140311112342.GE21216@lee--X1>
References: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
 <531EEA39.50504@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531EEA39.50504@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >
> >This patch adds support to rev E board of B2020 which has few minor
> >changes :
> >	PHY reset PIO (Change from PIO30 to PIO07)
> >	Power LED(Green) Control(Change from PIO47 to PIO13)
> 
> I thought we decided last October to support only one revision of
> the b2020 board.
> 
> The idea was to create an external git to provide DTS for all our
> boards, and only have a minimal subset in in the kernel.

Ah, I was unaware of that conversation/decision. If that's the case we
can scrap this submission along with the following patch.

JOOI, what happens if I want to boot Mainline on my revE board? It
won't be fully functional will it? That will be a shame. The LEDs, not
so much, but networking is a pretty big piece of functionality to
lose.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
