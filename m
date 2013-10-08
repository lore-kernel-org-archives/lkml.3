Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3JHH5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:57:47 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54843 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3JHH5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <1380370138-3513-5-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
	<1380370138-3513-5-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 8 Oct 2013 09:57:44 +0200
Message-ID: <CACRpkdbsLD66y5OLOvmYhU2AwNX01q8c9fnzDqr-BcRW5mh7QA@mail.gmail.com>
Subject: Re: [PATCH 05/11] pinctrl: imx53: Remove redundant of_match_ptr
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 2:08 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> The data structure of_match_ptr() protects is always compiled in.
> Hence of_match_ptr() is not needed.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.

Yours,
Linus Walleij
