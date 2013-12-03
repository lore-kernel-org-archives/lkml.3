Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3LCJxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:53:30 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55896 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3LCJx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:53:27 -0500
Date: Tue, 3 Dec 2013 09:53:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, sameo@linux.intel.com,
        Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/15] mfd: menelaus: Drop __exit section annotation
Message-ID: <20131203095322.GG11828@lee--X1>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
 <20131203095136.GF11828@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131203095136.GF11828@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The code looks mostly fine, but the implementation of the commit logs
> seems lazy. Please submit a v3 using coherent sentences with full
> explanations and correct punctuation.

Also use the full length of the provided buffer, which I believe is 72
chars, but happy to be correct on that one. It's certainly not 40
chars however.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
