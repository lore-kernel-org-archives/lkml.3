Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaE1HVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:21:49 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46799 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaE1HVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:21:48 -0400
Message-ID: <53858E89.9040102@dev.rtsoft.ru>
Date: Wed, 28 May 2014 11:21:45 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
References: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru> <5384BFC8.9060800@cogentembedded.com>
In-Reply-To: <5384BFC8.9060800@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.05.2014 20:39, Sergei Shtylyov пишет:
> Hello.
> 
> On 05/27/2014 08:56 AM, Nikita Yushchenko wrote:
> 
>> This access causes hang on Freescale P2020DS board (that has OHCI
>> provided by ULI 1533 chip).
> 
>> Since preserving OHCI_FMINTERVAL was originally done only for NVIDIA
>> hardware and only later (in c6187597) was turned unconditional, and
>> c6187597 commit message again mentions only NVIDIA, I think it should be
> 
>    Please also specify that commit's summary line in parens.

Sorry but can't get what you mean. Could you please be a bit more verbose?

Nikita

