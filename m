Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaDRTlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:41:50 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52481 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbaDRTlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:41:47 -0400
Message-ID: <1397850104.4750.8.camel@x220>
Subject: Re: [PATCH 01/28] nios2: Build infrastructure
From: Paul Bolle <pebolle@tiscali.nl>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Date: Fri, 18 Apr 2014 21:41:44 +0200
In-Reply-To: <1397824031-4892-2-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	 <1397824031-4892-2-git-send-email-lftan@altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2014 19:41:45.0308 (UTC) FILETIME=[3B0161C0:01CF5B3E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-18 at 20:26 +0800, Ley Foon Tan wrote:
> diff --git a/arch/nios2/kernel/Makefile b/arch/nios2/kernel/Makefile
[...]
> +obj-$(CONFIG_CONSOLE)		+= console.o

CONFIG_CONSOLE seems never to be defined. And there appears to be no
arch/nios2/console.c or .../console.S anyway.


Paul Bolle

