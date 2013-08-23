Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3HWS4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:56:35 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34705 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab3HWS4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <1377259662-17401-1-git-send-email-sachin.kamat@linaro.org>
References: <1377259662-17401-1-git-send-email-sachin.kamat@linaro.org>
Date: Fri, 23 Aug 2013 20:56:32 +0200
Message-ID: <CACRpkda9kryUvqG8ogbzPmdxt15gPW-DXkzcomMizp6Ae1MeCQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: ab8500-debugfs: Staticize local variables
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 2:07 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Local variables referenced only in this file are made static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
