Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaIURCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:02:25 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:60662 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaIURCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:02:24 -0400
X-ME-Helo: beldin
X-ME-Date: Sun, 21 Sep 2014 19:02:20 +0200
X-ME-IP: 90.16.208.226
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH 7/8] arm: mach-pxa: Convert pr_warning to pr_warn
References: <cover.1410632834.git.joe@perches.com>
	<70f104441791b08aadef9d7b72018161e9e773b0.1410632835.git.joe@perches.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 21 Sep 2014 19:02:07 +0200
In-Reply-To: <70f104441791b08aadef9d7b72018161e9e773b0.1410632835.git.joe@perches.com>
	(Joe Perches's message of "Sat, 13 Sep 2014 11:31:18 -0700")
Message-ID: <871tr4nbzk.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Use the more common pr_warn.
>
> Other miscellanea:
>
> o Coalesce formats
> o Realign arguments
>
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to pxa/cleanup branch, thanks.

--
Robert
