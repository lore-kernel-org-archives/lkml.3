Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3IWKxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:53:18 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:52159 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3IWKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <1379372965-22359-18-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
	<1379372965-22359-18-git-send-email-robherring2@gmail.com>
Date: Mon, 23 Sep 2013 14:53:13 +0400
Message-ID: <CAMo8BfJco_W1NpE3LgyzozgFXdwsUjb5PWytP6gwY9Hde7KR_A@mail.gmail.com>
Subject: Re: [PATCH 17/28] xtensa: use early_init_dt_scan
From: Max Filippov <jcmvbkbc@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 3:09 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Convert xtensa to use new early_init_dt_scan function.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: linux-xtensa@linux-xtensa.org
> ---
>  arch/xtensa/kernel/setup.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
