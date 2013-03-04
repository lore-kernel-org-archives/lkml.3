Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3CDGOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 01:14:39 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:62328 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3CDGOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 01:14:38 -0500
MIME-Version: 1.0
In-Reply-To: <1361348956-4387-1-git-send-email-fabio.baltieri@linaro.org>
References: <1361348956-4387-1-git-send-email-fabio.baltieri@linaro.org>
Date: Mon, 4 Mar 2013 07:14:37 +0100
Message-ID: <CACRpkdbF0gjGt2BxzwAAxjWqGbybuzne+43vSKUiH_tqLQTFPQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: read the correct soc_id number
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 9:29 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Fix db8500_read_soc_id() to read all five soc_id number locations
> instead of repeating the second one two times.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Thanks, patch applied!

Yours,
Linus Walleij
