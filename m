Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3IWKxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:53:00 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:46424 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3IWKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <1379372965-22359-8-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
	<1379372965-22359-8-git-send-email-robherring2@gmail.com>
Date: Mon, 23 Sep 2013 14:52:57 +0400
Message-ID: <CAMo8BfJ-NXjXrYk6Ky6MeDWiJGE9MFm__mLgWAt-eiH2W4jhjA@mail.gmail.com>
Subject: Re: [PATCH 07/28] xtensa: use unflatten_and_copy_device_tree
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
> Use the common unflatten_and_copy_device_tree to copy the built-in FDT
> out of init section.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: linux-xtensa@linux-xtensa.org
> ---
>  arch/xtensa/kernel/setup.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
