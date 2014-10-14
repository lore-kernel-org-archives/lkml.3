Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaJNKbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:31:13 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48902 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752778AbaJNKbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:31:12 -0400
Message-ID: <543CFB69.50300@hurleysoftware.com>
Date: Tue, 14 Oct 2014 06:31:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>, gregkh@linuxfoundation.org
CC: arnd@arndb.de, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
References: <1413276146-20388-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1413276146-20388-1-git-send-email-jingchang.lu@freescale.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 04:42 AM, Jingchang Lu wrote:
> This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
> "serial: of-serial: add PM suspend/resume support", which disables
> the uart clock on suspend, but also causes a hardware hang on register
> access if no_console_suspend command line option is used.
> 
> Also, not every of_serial device is an 8250 port, so the serial8250
> suspend/resume functions should only be applied to a real 8250 port.

Thanks.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

