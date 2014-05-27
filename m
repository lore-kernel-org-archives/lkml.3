Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaE0Qji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:39:38 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56404 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaE0Qjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:39:36 -0400
Message-ID: <5384BFC8.9060800@cogentembedded.com>
Date: Tue, 27 May 2014 20:39:36 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
References: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru>
In-Reply-To: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/27/2014 08:56 AM, Nikita Yushchenko wrote:

> This access causes hang on Freescale P2020DS board (that has OHCI
> provided by ULI 1533 chip).

> Since preserving OHCI_FMINTERVAL was originally done only for NVIDIA
> hardware and only later (in c6187597) was turned unconditional, and
> c6187597 commit message again mentions only NVIDIA, I think it should be

    Please also specify that commit's summary line in parens.

> safe to disable preserving OHCI_FMINTERVAL if device vendor is ULI.

> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
> ---
>   drivers/usb/host/pci-quirks.c |    8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)

WBR, Sergei

