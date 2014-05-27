Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaE0SBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:01:03 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47942 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaE0SBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:01:01 -0400
Date: Tue, 27 May 2014 11:01:12 -0700
From: Olof Johansson <olof@lixom.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com
Subject: Re: [PATCH] ARM: STi: DT: STiH41x: Convert all uppercase non-defines
 to lowercase
Message-ID: <20140527180112.GB26141@quad.lixom.net>
References: <1401195188-23677-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401195188-23677-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 01:53:08PM +0100, Lee Jones wrote:
> Suggested-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/stih415-pinctrl.dtsi   | 340 +++++++++++++++---------------
>  arch/arm/boot/dts/stih416-b2020-revE.dts |   6 +-
>  arch/arm/boot/dts/stih416-pinctrl.dtsi   | 342 +++++++++++++++----------------
>  arch/arm/boot/dts/stih41x-b2000.dtsi     |   6 +-
>  arch/arm/boot/dts/stih41x-b2020.dtsi     |   6 +-
>  5 files changed, 350 insertions(+), 350 deletions(-)

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
