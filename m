Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbaIEAO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:14:57 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48201 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbaIEAOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:14:55 -0400
MIME-Version: 1.0
In-Reply-To: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Thu, 4 Sep 2014 17:14:53 -0700
Message-ID: <CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
From: Bjorn Andersson <bjorn@kryo.se>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 1:23 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> Introduce the irq_read_line() function to allow device drivers to read
> the current logical state of an input when the hardware only exposes
> this through status bits in the interrupt controller.
>
> The new function is backed by a new callback function in the irq_chip -
> irq_read_line() - that can be implemented by irq_chips that owns such
> status bits.
>
> Based on rfc patch from April 2011 by Abhijeet.
>
> Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

ping?
