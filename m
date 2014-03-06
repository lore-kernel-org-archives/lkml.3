Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaCFMnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:43:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:53199 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaCFMm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:42:59 -0500
Message-ID: <53186D4E.4000706@linutronix.de>
Date: Thu, 06 Mar 2014 13:42:54 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Mugunthan V N <mugunthanvnm@ti.com>, bcousson@baylibre.com,
        tony@atomide.com
CC: devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [RESEND PATCH 1/1] arm: dts: am33xx: correcting dt node unit
 address for usb
References: <1394109094-19205-1-git-send-email-mugunthanvnm@ti.com>
In-Reply-To: <1394109094-19205-1-git-send-email-mugunthanvnm@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 01:31 PM, Mugunthan V N wrote:
> DT node's unit address should be its own register offset address to make it a
> unique across the system. This patch corrects the incorrect USB entries with
> correct register offset for unit address.
> 
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
