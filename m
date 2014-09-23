Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbaIWPKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:10:22 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45560 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaIWPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:10:19 -0400
MIME-Version: 1.0
In-Reply-To: <b54e0c34addb2b9cc4c3a20d5afc8b27a3096d09.1410632835.git.joe@perches.com>
References: <cover.1410632834.git.joe@perches.com>
	<b54e0c34addb2b9cc4c3a20d5afc8b27a3096d09.1410632835.git.joe@perches.com>
Date: Tue, 23 Sep 2014 17:10:18 +0200
Message-ID: <CACRpkdbHCAVUL6VwSSNdV1OXgiC2dPCLnhVm7ih9XMcwM-a29w@mail.gmail.com>
Subject: Re: [PATCH 8/8] arm: mach-u300: Convert pr_warning to pr_warn
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 8:31 PM, Joe Perches <joe@perches.com> wrote:

> Use the more common pr_warn.
>
> Other miscellanea:
>
> o Coalesce formats
> o Realign arguments
> o typo fixes of Siple to Simple
>
> Signed-off-by: Joe Perches <joe@perches.com>

Patch applied.

Yours,
Linus Walleij
