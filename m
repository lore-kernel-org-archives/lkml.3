Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaGJNI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:08:58 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:54972 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbaGJNI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:08:56 -0400
MIME-Version: 1.0
In-Reply-To: <1404393243-7324-4-git-send-email-svarbanov@mm-sol.com>
References: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com>
	<1404393243-7324-4-git-send-email-svarbanov@mm-sol.com>
Date: Thu, 10 Jul 2014 06:08:55 -0700
Message-ID: <CAJAp7Ohis95K9Fw5ff7jfed5YFwRaMqHL-FToPqz7YU_Ux3zEg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/5] rtc: add qpnp rtc driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 6:14 AM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
[...]
> +static const struct of_device_id qpnp_rtc_table[] = {
> +       { .compatible = "qcom,qpnp-rtc", },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, rtc_qpnp_table);

We have had a lot of discussions related to how to name pm8x41
drivers; as they obviously fall under pm8xxx in most peoples eyes.

As you guys have explained, QPNP is defining the split of address
space and how interrupts are layed out. To me this does however not
say anything related to the actual functionality; e.g. the rtc in this
case.

Are you by this patch saying that this is the one and only rtc
hardware that will ever be spun under the QPNP umbrella?
I would expect the naming to be more specific; and definitely the
compatible to be specific.

This concern goes for all the qpnp drivers.

Regards,
Bjorn
