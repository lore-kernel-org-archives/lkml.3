Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3E1KK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:10:29 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:57897 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3E1KK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:10:28 -0400
Date: Tue, 28 May 2013 11:10:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: Re: [PATCH 1/3] ARM: ux500: use #include syntax to include *.dtsi.
Message-ID: <20130528101023.GL22683@gmail.com>
References: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
 <1369661455-17839-2-git-send-email-gabriel.fernandez.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369661455-17839-2-git-send-email-gabriel.fernandez.st@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Gabriel Fernandez wrote:

> From: Gabriel Fernandez <gabriel.fernandez@st.com>
> 
> This patch prepares the use of '#define' into dts files.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> ---
>  arch/arm/boot/dts/ccu8540.dts     | 2 +-
>  arch/arm/boot/dts/ccu9540.dts     | 2 +-
>  arch/arm/boot/dts/dbx5x0.dtsi     | 2 +-
>  arch/arm/boot/dts/href.dtsi       | 2 +-
>  arch/arm/boot/dts/hrefprev60.dts  | 6 +++---
>  arch/arm/boot/dts/hrefv60plus.dts | 6 +++---
>  arch/arm/boot/dts/snowball.dts    | 2 +-
>  7 files changed, 11 insertions(+), 11 deletions(-)

Nice.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
