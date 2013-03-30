Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3C3Mo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:44:27 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36235 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3C3Mo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:44:26 -0400
MIME-Version: 1.0
In-Reply-To: <1364647402.3822.1.camel@phoenix>
References: <1364647402.3822.1.camel@phoenix>
Date: Sat, 30 Mar 2013 18:14:25 +0530
Message-ID: <CAKohpokY-ZQHANgx2KvJ4jGpw2yGBue1gB0f74PsJPwCBgb=-Q@mail.gmail.com>
Subject: Re: [PATCH] pwm: spear: Fix checking return value of clk_enable() and clk_prepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2013 18:13, Axel Lin <axel.lin@ingics.com> wrote:
> The logic to check return value of clk_enable() and clk_prepare() is reversed,
> fix it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: <stable@vger.kernel.org>
> ---
> This is v3 of "pwm: spear: Fix enable pwm output".
> I change the subject line because it also fixes checking return value of
> clk_prepare().
> Also add cc stable.
>
> Axel
>
>  drivers/pwm/pwm-spear.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Sorry for the delays caused due to me.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
