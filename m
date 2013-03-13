Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab3CMRJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:09:21 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:57834 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3CMRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <1363168069-11331-1-git-send-email-sachin.kamat@linaro.org>
References: <1363168069-11331-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 13 Mar 2013 22:39:18 +0530
Message-ID: <CADTbHxrF5M++Y5ku90uN7n6Jx=o80qY+dFX+B_s0udSC06D-PQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] clk: Fix incorrect return type in clk.c
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Mar 13, 2013 at 3:17 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Return type of function clk_propagate_rate_change is a pointer.
> But 0 was being returned. Change it to NULL.
> Silences the following warning:
> drivers/clk/clk.c:977:24: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/clk/clk.c |    2 +-

Looks good to me.
Reviewed-by: Pankaj Jangra <jangra.pankaj9@gmail.com>

Regards,
Pankaj Jangra
