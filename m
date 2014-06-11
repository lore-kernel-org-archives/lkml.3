Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbaFKMpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:45:16 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58851 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaFKMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:45:14 -0400
MIME-Version: 1.0
In-Reply-To: <1401700128-11506-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1401700128-11506-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 11 Jun 2014 14:45:13 +0200
Message-ID: <CACRpkdZG15PUTTUZsL6ShNoRi7AQFeehj9Smt5O4=9cPNCk0qQ@mail.gmail.com>
Subject: Re: [PATCH v6 02/12] mmc: mmci: Add Qualcomm specific register defines.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 11:08 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds a Qualcomm SD Card controller specific register variations
> to header file. Qualcomm SDCC controller is pl180, with slight changes in
> the register layout from standard pl180 register set.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
