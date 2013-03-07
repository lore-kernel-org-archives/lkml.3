Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab3CGMSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:18:39 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:40808 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3CGMSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:18:38 -0500
Message-ID: <51388575.4050506@cogentembedded.com>
Date: Thu, 07 Mar 2013 16:17:57 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: linux-arm-kernel@lists.infradead.org, richard.genoud@gmail.com,
        JM.Lin@atmel.com, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net, plagnioj@jcrosoft.com
Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after xfer->speed_hz
 set
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com> <1362626815-6628-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1362626815-6628-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-03-2013 7:26, Wenyou Yang wrote:

> commit: 059b8ffeee5b427949872bb6ed5db5ae0788054e

    Please also specify the summary line of that commit in parens (or however 
you like).

> cause the atmel spi probing failure.

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org

WBR, Sergei

