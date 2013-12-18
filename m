Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3LRRnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:43:08 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:64802 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3LRRnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:43:05 -0500
Message-ID: <52B1ECBB.6000003@cogentembedded.com>
Date: Wed, 18 Dec 2013 21:43:07 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Apelete Seketeli <apelete@seketeli.net>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 1/3] mips: qi_lb60: add defconfig for Ben NanoNote
References: <1387324561-21578-1-git-send-email-apelete@seketeli.net> <1387324561-21578-2-git-send-email-apelete@seketeli.net> <52B1B868.8010807@cogentembedded.com> <20131218160049.GO4648@amegan>
In-Reply-To: <20131218160049.GO4648@amegan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/18/2013 07:00 PM, Apelete Seketeli wrote:

>>> Add defconfig for the Ben NanoNote handheld computer which is built
>>> around QI_LB60 board and Ingenic JZ4740 MIPS SoC.

>>> Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
>>> ---
>>>   arch/mips/configs/qi_lb60_defconfig |  188 +++++++++++++++++++++++++++++++++++
>>>   1 file changed, 188 insertions(+)
>>>   create mode 100644 arch/mips/configs/qi_lb60_defconfig

>>     This should be sent to linux-mips@linux-mips.org and pushed thru
>> the MIPS tree. No need to send this patch to linux-usb.

> Understood, will send it to linux-mips@linux-mips.org.
> Please ignore this patch for USB tree.

    Generally, please use scripts/get_maintainer.pl to determine where a patch 
should be mailed to.

> Cheers.

WBR, Sergei

