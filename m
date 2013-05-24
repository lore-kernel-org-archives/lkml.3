Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab3EXIpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:45:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61255 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759806Ab3EXIph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:45:37 -0400
Date: Fri, 24 May 2013 09:45:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: patrice.chotard.st@gmail.com
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        fabio.baltieri@linaro.org, Patrice Chotard <patrice.chotard@st.com>
Subject: Re: [PATCH] pinctrl: abx500: suppress unused mutex
Message-ID: <20130524084532.GS22683@gmail.com>
References: <1369323102-3030-1-git-send-email-patrice.chotard.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369323102-3030-1-git-send-email-patrice.chotard.st@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013, patrice.chotard.st@gmail.com wrote:

> From: Patrice Chotard <patrice.chotard@st.com>
> 
> Suppress a mutex which was initialized on probe
> and destroyed on remove but never used.
> 
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> ---
>  drivers/pinctrl/pinctrl-abx500.c |    9 ---------
>  1 file changed, 9 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
