Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaEWJHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:07:00 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:48331 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaEWJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <1400146643-30179-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146643-30179-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 23 May 2014 11:06:57 +0200
Message-ID: <CACRpkdZX9zyc2agXbbAXoODA9c6iLgJxjq7XVBRpfRPtkxvh3g@mail.gmail.com>
Subject: Re: [PATCH v2 09/14] mmc: mmci: add edge support to data and command
 out in variant data.
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

On Thu, May 15, 2014 at 11:37 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds edge support for data and command out to variant structure
> giving more flexibility to the driver to support more SOCs which have
> different clock register layout.
>
> Without this patch other new SOCs like Qcom will have to add more code to
> special case them
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
