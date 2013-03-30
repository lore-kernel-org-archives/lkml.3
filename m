Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3C3Jzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 05:55:43 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45554 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab3C3Jzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 05:55:42 -0400
MIME-Version: 1.0
In-Reply-To: <1364621848.3568.0.camel@phoenix>
References: <1364621848.3568.0.camel@phoenix>
Date: Sat, 30 Mar 2013 15:25:41 +0530
Message-ID: <CAKohpo=xQC_pzc19RP1TncO3XJLj7k-_JyvT3n9UZFTEjYOizw@mail.gmail.com>
Subject: Re: [PATCH v2] pwm: spear: Fix enable pwm output
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2013 11:07, Axel Lin <axel.lin@ingics.com> wrote:
> The logic to check return value of clk_enable() is reversed, thus
> when clk_enable() passes PWMCR_PWM_ENABLE bit is not set. Fix it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-spear.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I am so sorry. clk_prepare also has the same issue :(
Please fix that too and i will ack it ASAP.

@Shiraz: Any idea how they went through?
