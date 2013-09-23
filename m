Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3IWTPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:15:36 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36828 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3IWTPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <52377568.6010204@gmail.com>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
	<1379320326-13241-4-git-send-email-treding@nvidia.com>
	<52377568.6010204@gmail.com>
Date: Mon, 23 Sep 2013 21:15:32 +0200
Message-ID: <CACRpkdans_2QFyjgFT-HMMG_H1o3ZUYXP9GvXuSqr-0R1Nhfbw@mail.gmail.com>
Subject: Re: [PATCH 3/9] irqdomain: Introduce __irq_create_of_mapping()
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:17 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 09/16/2013 03:32 AM, Thierry Reding wrote:
>> This is a version of irq_create_of_mapping() that propagates the precise
>> error code instead of returning 0 for all errors. It will be used in
>> subsequent patches to allow further propagation of error codes.
>>
>> To avoid code duplication, implement irq_create_of_mapping() as a
>> wrapper around the new __irq_create_of_mapping().
>
> This function is a manageable number of callers that the callers should
> just be updated and avoid the wrapper.

I second this and also don't want the first patch to use a wrapper.

Yours,
Linus Walleij
