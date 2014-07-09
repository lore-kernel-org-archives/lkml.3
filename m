Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaGIMzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:55:45 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:53815 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaGIMzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:55:43 -0400
Message-ID: <53BD3BD4.9090602@cogentembedded.com>
Date: Wed, 09 Jul 2014 16:55:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, balbi@ti.com
CC: tony@atomide.com, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removes FIXME message in usb.c
References: <1404871119-4324-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1404871119-4324-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/09/2014 05:58 AM, Nicholas Krause wrote:

> This patch removes a fixme message in this file:wq for setting the usb 2

    The vim's commands interspersed with text? :-)

> speed on the board to the correct level. We need to depend on the
> bootloader for doing this as the wires may be shared for the other
> things on the board with the usb chipset.

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
[...]

WBR, Sergei

