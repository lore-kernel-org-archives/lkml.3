Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3C0Ic6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:32:58 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58141 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3C0Ic4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:32:56 -0400
MIME-Version: 1.0
In-Reply-To: <1362388179-26841-1-git-send-email-sachin.kamat@linaro.org>
References: <1362388179-26841-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 27 Mar 2013 09:32:55 +0100
Message-ID: <CACRpkdY3DNfFPYcMWwoDuhdZa=5bPVz4=NbdJ+WxG_UF5OnTsA@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio/vt8500: Convert to devm_ioremap_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux@prisktech.co.nz,
        grant.likely@secretlab.ca, thierry.reding@avionic-design.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 10:09 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied with Tony's and Thierry's ACKs/Reviewed-by.

Yours,
Linus Walleij
