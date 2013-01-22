Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3AVJNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:13:52 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40501 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab3AVJNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:13:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130118175827.3982.65450@quantum>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
	<1357282858-2112-7-git-send-email-pgaikwad@nvidia.com>
	<20130118175827.3982.65450@quantum>
Date: Tue, 22 Jan 2013 10:13:08 +0100
Message-ID: <CACRpkdZapUtqzQo3pJizfT8-SEe-up_DD3Z_eY-cM7o1_sUTPQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] clk: vexpress: Use common of_clk_init() function
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>, swarren@nvidia.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        maxime.ripard@free-electrons.com, linux@prisktech.co.nz,
        josh.cartwright@ni.com, Pawel Moll <pawel.moll@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 6:58 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Prashant Gaikwad (2013-01-03 23:00:58)
>> Use common of_clk_init() function for clock initialization.
>>
>> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
>
> Pawel or Linus,
>
> Can I get a Tested-by before I take this series into clk-next?

For this specific patch, I don't have a vexpress board, sorry...

Yours,
Linus Walleij
