Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaLDVSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:18:24 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:54741 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaLDVSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:18:23 -0500
X-ME-Helo: beldin
X-ME-Date: Thu, 04 Dec 2014 22:18:21 +0100
X-ME-IP: 109.214.46.91
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH] arm: pxa: fix pxa27x device-tree support kconfig
References: <1417206768-5840-1-git-send-email-robert.jarzmik@free.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 04 Dec 2014 22:18:19 +0100
In-Reply-To: <1417206768-5840-1-git-send-email-robert.jarzmik@free.fr> (Robert
	Jarzmik's message of "Fri, 28 Nov 2014 21:32:48 +0100")
Message-ID: <87a933yuzo.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Remove the useless CPU_PXA27x non existing kconfig option.
> The true options is PXA27x, which is already selected.
>
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Queued to pxa/for-next.

-- 
Robert
