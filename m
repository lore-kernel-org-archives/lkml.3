Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3HGQxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:53:47 -0400
Received: from smtp.infotech.no ([82.134.31.41]:54100 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab3HGQxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:53:46 -0400
Message-ID: <52027B6A.6020306@interlog.com>
Date: Wed, 07 Aug 2013 12:52:58 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: add missing uart clocks DT entries
References: <1375892984-2835-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375892984-2835-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-07 12:29 PM, Boris BREZILLON wrote:
> Add clocks to clock lookup table for uart DT entries.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
