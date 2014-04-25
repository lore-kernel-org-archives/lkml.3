Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaDYNBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:01:32 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:61735 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaDYNAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:00:24 -0400
MIME-Version: 1.0
In-Reply-To: <1398429171-8566-1-git-send-email-iivanov@mm-sol.com>
References: <1398429171-8566-1-git-send-email-iivanov@mm-sol.com>
Date: Fri, 25 Apr 2014 08:00:22 -0500
Message-ID: <CAL_JsqJMs1ULgLMAia6ojz+i3b=7W6hxyqSTMATo96i0cS2n0g@mail.gmail.com>
Subject: Re: [RFC PATCH] mfd: pm8x41: Naive function devices registration
From: Rob Herring <robherring2@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 7:32 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
> Currently functions that exist in both the controller at the
> same address offset can not be specified with the same names.
>
> Adding Unique Slave ID device address to prefix function
> device names fixes this.
>
> Function devices are SPMI devices, so register them on
> SPMI bus.
>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/mfd/pm8x41.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++----

No, this should be fixed in the core, not the driver.

Rob
