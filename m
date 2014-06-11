Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaFKMr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:47:29 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46350 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaFKMr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:47:27 -0400
MIME-Version: 1.0
In-Reply-To: <1401700187-11793-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1401700187-11793-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 11 Jun 2014 14:47:27 +0200
Message-ID: <CACRpkdbeGSwq8fAxj-M75NRLN=Jqqn4ExJ7bF3XC=o2FRVySJA@mail.gmail.com>
Subject: Re: [PATCH v6 09/12] mmc: mmci: add f_max to variant structure
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

On Mon, Jun 2, 2014 at 11:09 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Some of the controller have maximum supported frequency, This patch adds
> support in variant data structure to specify such restrictions. This
> gives more flexibility in calculating the f_max before passing it to
> mmc-core.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
