Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaJ1OkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:40:20 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45799 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaJ1OkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <1413454672-27400-12-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
	<1413454672-27400-12-git-send-email-maxime.ripard@free-electrons.com>
Date: Tue, 28 Oct 2014 15:40:17 +0100
Message-ID: <CACRpkdbPvJ7q54vC-suOQ4Qnk8TpWdSWpoGir8-Q2cQzgCvzRg@mail.gmail.com>
Subject: Re: [PATCH v2 11/53] dmaengine: coh901318: Split device_control
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine@free-electrons.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 12:17 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Split the device_control callback of the ST-Ericsson COH901318 DMA driver to
> make use of the newly introduced callbacks, that will eventually be used to
> retrieve slave capabilities.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
