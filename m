Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3JHHyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:54:09 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51672 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab3JHHyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 8 Oct 2013 09:54:07 +0200
Message-ID: <CACRpkda1EfqGHHQJ7s2ku+C4Mc5dhrcvjL8U_EHenj1=cWjxxA@mail.gmail.com>
Subject: Re: [PATCH 01/11] pinctrl: at91: Remove redundant of_match_ptr
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
