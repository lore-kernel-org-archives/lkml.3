Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3CKKXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:23:34 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43187 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3CKKXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <1362987503-6449-1-git-send-email-silviupopescu1990@gmail.com>
References: <1362987503-6449-1-git-send-email-silviupopescu1990@gmail.com>
Date: Mon, 11 Mar 2013 15:53:31 +0530
Message-ID: <CAK9yfHxJNtdYdx4pwfq_F2HBvOxvumt+XFsdQQjh2xHB9_s3sg@mail.gmail.com>
Subject: Re: [PATCH] watchdog: convert to devm_ioremap_resource()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be, ben-linux@fluff.org,
        kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11 March 2013 13:08, Silviu-Mihai Popescu
<silviupopescu1990@gmail.com> wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
>
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
>
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

I have already submitted a similar patchset to do this:
http://www.spinics.net/lists/linux-watchdog/msg02101.html


-- 
With warm regards,
Sachin
