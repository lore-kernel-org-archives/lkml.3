Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaAJKBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:01:11 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40605 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaAJKBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:01:07 -0500
Date: Fri, 10 Jan 2014 10:01:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mfd/stw481x.c: fix a typo
Message-ID: <20140110100102.GB28141@lee--X1>
References: <1389202490-31506-1-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389202490-31506-1-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The sentence is not proper English due to a minor typo of "addess". The 'r'
> letter is missing which this change is now amending. This was caught while
> reading the driver source for getting more information about it, and then I ran
> the vim spellchecker to make sure there are no more typos in this file.
> 
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/mfd/stw481x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I'm feeling genorous today, so I'll apply it and change the subject
line for you. This is the second time I've told you to do,

  `git log --oneline -- <subsystem>`

in order to find the correct commit log format for the subsystem
you're applying patches to. Next time I'll just NACK the patch and
you'll have to fix it yourself.

Patch applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
