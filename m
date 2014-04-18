Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaDRTQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:16:19 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:59242 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbaDRTQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:16:15 -0400
Message-ID: <1397848572.4750.4.camel@x220>
Subject: Re: [PATCH 01/28] nios2: Build infrastructure
From: Paul Bolle <pebolle@tiscali.nl>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Date: Fri, 18 Apr 2014 21:16:12 +0200
In-Reply-To: <1397824031-4892-2-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	 <1397824031-4892-2-git-send-email-lftan@altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2014 19:16:13.0401 (UTC) FILETIME=[A9EAEC90:01CF5B3A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-18 at 20:26 +0800, Ley Foon Tan wrote:
> diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
>[...]
> +config GENERIC_FIND_NEXT_BIT
> +	def_bool y

This one is not needed, see commit 63e424c84429 ("arch: remove
CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}").

> +config NO_IOPORT
> +	def_bool y

Did you mean NO_IOPORT_MAP?


Paul Bolle

