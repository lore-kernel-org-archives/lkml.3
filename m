Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaBIVoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:44:30 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:61668 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbaBIVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:44:29 -0500
Message-ID: <1391982267.25855.63.camel@x220>
Subject: Re: [PATCH 08/28] Remove SYS_HAS_DMA_OPS
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "open list:MIPS" <linux-mips@linux-mips.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 22:44:27 +0100
In-Reply-To: <1391971686-9517-9-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-9-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 21:44:28.0288 (UTC) FILETIME=[1B97F800:01CF25E0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.

I don't think a symbol with that name was ever part of the tree (but I
didn't look past v2.6.12). It seems just a typo, but it's unclear what
was intended here. It's a nop now, so safe to remove.

> Signed-off-by: Richard Weinberger <richard@nod.at>

So, perhaps Richard should update the commit explanation. But I'm fine
with the patch itself:
    Acked-by: Paul Bolle <pebolle@tiscali.nl>
 

Paul Bolle

