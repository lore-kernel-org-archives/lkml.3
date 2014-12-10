Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaLJKlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:41:31 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39297 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbaLJKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:41:29 -0500
MIME-Version: 1.0
In-Reply-To: <1418051276-5476-2-git-send-email-ricardo.ribalda@gmail.com>
References: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com> <1418051276-5476-2-git-send-email-ricardo.ribalda@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 10 Dec 2014 19:41:08 +0900
Message-ID: <CAAVeFu+Q5V0_D=9XbGPW=sbnLQCrgJ9SqEv7ppwoGy4yUN+L9w@mail.gmail.com>
Subject: Re: [PATCH 1/4] gpio/xilinx: remove offset property
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 12:07 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Instead of calculating the register offset per call, pre-calculate it on
> probe time.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Nice optimization.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
