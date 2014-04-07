Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaDGXxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:53:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47892 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaDGXxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <1391700529-11816-2-git-send-email-iivanov@mm-sol.com>
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com>
	<1391700529-11816-2-git-send-email-iivanov@mm-sol.com>
Date: Mon, 7 Apr 2014 18:53:02 -0500
Message-ID: <CAOZdJXVE7MSMBaL+bt0kjw5LEidz-aVp+vrWqQWkye6HdE7EeA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
From: Timur Tabi <timur@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 9:28 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> +                       spi8_default: spi8_default {
> +                               mosi {
> +                                       pins = "gpio45";
> +                                       function = "blsp_spi8";
> +                               };
> +                               miso {
> +                                       pins = "gpio46";
> +                                       function = "blsp_spi8";
> +                               };
> +                               cs {
> +                                       pins = "gpio47";
> +                                       function = "blsp_spi8";
> +                               };
> +                               clk {
> +                                       pins = "gpio48";
> +                                       function = "blsp_spi8";
> +                               };

I'm confused by this.  Isn't this information already defined in the
pinctrl-msm8x74.c driver?

static const char * const blsp_spi8_groups[] = {
    "gpio45", "gpio46", "gpio47", "gpio48"
};
