Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3BDFQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 00:16:14 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50317 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3BDFQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 00:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <1359713277-14228-1-git-send-email-sachin.kamat@linaro.org>
References: <1359713277-14228-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 4 Feb 2013 10:46:12 +0530
Message-ID: <CAK9yfHybaaHwLdcv7a=rJuAY1NDA8+9_1DzGV=g48XhvagfKDA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Input: tegra-kbc- Convert to devm_ioremap_resource()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 1 February 2013 15:37, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> ---
>  Patch based & compile tested on linux-next tree (20130128).
>  Changes since v1:
>  * Dropped the error message as it is now handled by devm_ioremap_resource()
>  itself.
> ---

Just realized that most of these patches (converting to
devm_ioremap_resource) which were based on linux-next tree do not
apply on the driver-core tree due to missing dependent patches in it.
I will re-send them once 3.9-rc1 is out. For now, please ignore them.

- -
With warm regards,
Sachin
