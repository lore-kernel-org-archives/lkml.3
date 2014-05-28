Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaE1L5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:57:17 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:40270 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaE1L5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:57:14 -0400
Message-ID: <5385CF1D.6020801@cogentembedded.com>
Date: Wed, 28 May 2014 15:57:17 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
References: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru> <5384BFC8.9060800@cogentembedded.com> <53858E89.9040102@dev.rtsoft.ru>
In-Reply-To: <53858E89.9040102@dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-05-2014 11:21, Nikita Yushchenko wrote:

>>> This access causes hang on Freescale P2020DS board (that has OHCI
>>> provided by ULI 1533 chip).

>>> Since preserving OHCI_FMINTERVAL was originally done only for NVIDIA
>>> hardware and only later (in c6187597) was turned unconditional, and
>>> c6187597 commit message again mentions only NVIDIA, I think it should be

>>     Please also specify that commit's summary line in parens.

> Sorry but can't get what you mean. Could you please be a bit more verbose?

    Commit c6187597 (OHCI: final fix for NVIDIA problems (I hope)).

> Nikita

WBR, Sergei

