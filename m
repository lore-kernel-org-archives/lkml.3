Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3LRO7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:59:50 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:55906 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab3LRO7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:59:48 -0500
Message-ID: <52B1B868.8010807@cogentembedded.com>
Date: Wed, 18 Dec 2013 18:59:52 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Apelete Seketeli <apelete@seketeli.net>, linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 1/3] mips: qi_lb60: add defconfig for Ben NanoNote
References: <1387324561-21578-1-git-send-email-apelete@seketeli.net> <1387324561-21578-2-git-send-email-apelete@seketeli.net>
In-Reply-To: <1387324561-21578-2-git-send-email-apelete@seketeli.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-12-2013 3:55, Apelete Seketeli wrote:

> Add defconfig for the Ben NanoNote handheld computer which is built
> around QI_LB60 board and Ingenic JZ4740 MIPS SoC.

> Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> ---
>   arch/mips/configs/qi_lb60_defconfig |  188 +++++++++++++++++++++++++++++++++++
>   1 file changed, 188 insertions(+)
>   create mode 100644 arch/mips/configs/qi_lb60_defconfig

    This should be sent to linux-mips@linux-mips.org and pushed thru the MIPS 
tree. No need to send this patch to linux-usb.

WBR, Sergei

