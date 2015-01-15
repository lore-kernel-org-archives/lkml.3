Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbbAOET3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:19:29 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:38134 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbAOET1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:19:27 -0500
Message-ID: <54B73FC0.4060506@synopsys.com>
Date: Thu, 15 Jan 2015 09:49:12 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <robh@kernel.org>
CC: Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5] ARC: Dynamically determine BASE_BAUD from DeviceTree
References: <CAL_JsqLzzLajoQAT3nYd5zi4=+zchXfVVPnYNriAZZi4tpa6yA@mail.gmail.com> <1420889152-29361-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1420889152-29361-1-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Saturday 10 January 2015 04:56 PM, Vineet Gupta wrote:
> 8250 earlycon is broken on multi-platform ARC because the UART clk
> value (BASE_BAUD) is fixed at build time.
> 
> Instead, determine the appropriate UART clk at runtime; parse the
> devicetree early for platforms requiring alternate UART clk values
> (currently only the TB10X platform).
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-serial@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Rob Herring <robh@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/include/asm/serial.h | 23 +++++------------------
>  arch/arc/kernel/devtree.c     | 24 ++++++++++++++++++++++++

This being all in arch code, do you want me to take this in via ARC tree ?

Thx,
-Vineet

