Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab3GZUfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:35:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:39094 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3GZUfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:35:31 -0400
Message-ID: <51F2DD90.2030405@linutronix.de>
Date: Fri, 26 Jul 2013 22:35:28 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after
 removal
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-15-git-send-email-bigeasy@linutronix.de> <CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com> <51EEBE05.2040000@linutronix.de> <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com> <20130726163101.GB29819@linutronix.de> <CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com> <CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com> <51F2BE6F.3010008@linutronix.de> <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com> <51F2D427.7050106@linutronix.de> <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
In-Reply-To: <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 10:15 PM, Bin Liu wrote:
> Sebastian,

Hi Bin,

> I started thinking when I tried this git.ti.com 3.8 kernel, I might
> have done 'devmem2 0x47401c60 b 0x81' to manually set the SESSION bit
> after plugged a device. It was months ago, I don't quite remember what
> I tested.

Ah. You cheated! :)

> My build server is down this afternoon. Once it comes back next week,
> I will try 3.8 again, to see how I can help on this USB1 host mode
> issue. its devctl register should stay on 0x19 even nothing is
> connected.

Your help is greatly appreciated. To hear what will happen :)

Sebastian
