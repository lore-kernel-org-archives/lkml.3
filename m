Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaLRHyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:54:22 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:59402 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaLRHyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:54:21 -0500
From: Arnd Bergmann <arnd@linaro.org>
To: Chunyan Zhang <zhang.chunyan@linaro.org>
Cc: tglx@linutronix.de, davem@davemloft.net, john.stultz@linaro.org,
        dborkman@redhat.com, linux-kernel@vger.kernel.org,
        zhang.lyra@gmail.com
Subject: Re: [PATCH] ktime.h: Introduce ktime_ms_delta
Date: Thu, 18 Dec 2014 08:53:59 +0100
Message-ID: <1510743.FQ5unWipvQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418793095-18780-1-git-send-email-zhang.chunyan@linaro.org>
References: <1418793095-18780-1-git-send-email-zhang.chunyan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:F3FH3jjY8ZtdXf7wWOFM061aaSgMqvqMlbciuLTBBi/tdebOJiX
 n3vx1OMl2tDpGBMskJZ9Bd0txv0JxNXjPHtBdaFcDAeq3cwByhRl7lcvS7iTpUEM4wR4BkD
 gIz4jfWV7CAm/0BrNj6wyFhq3cNuLTCRWYaytN1WJn3dhymwpcriCNaaYBzjbWoNHXBDHca
 tgpvc46SP39NPiqJkAREw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 13:11:35 Chunyan Zhang wrote:
> This patch adds a reusable time difference function which returns the
> difference in millisecond, as often used in some driver code, e.g.
> mtd/test, media/rc, etc.
> 
> Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>

Acked-by: Arnd Bergmann <arnd@linaro.org>

Very nice!
