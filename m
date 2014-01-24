Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaAXVUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:20:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45205 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbaAXVUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:20:37 -0500
Message-ID: <52E2D904.6020608@zytor.com>
Date: Fri, 24 Jan 2014 13:20:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>, kys@microsoft.com,
        haiyangz@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, hyperv: bypass the timer_irq_works() check
References: <1390543371-10748-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1390543371-10748-1-git-send-email-jasowang@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 10:02 PM, Jason Wang wrote:
> This patch bypass the timer_irq_works() check for hyperv guest since:
> 
> - It was guaranteed to work.
> - timer_irq_works() may fail sometime due to the lpj calibration were inaccurate
>   in a hyperv guest or a buggy host.
> 
> In the future, we should get the tsc frequency from hypervisor and use preset
> lpj instead.
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

This should be in -stable, right?

	-hpa


