Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3LQTFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:05:09 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:33557 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3LQTFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:05:05 -0500
Message-ID: <1387306781.19078.288.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [BUG: 3.13.0-rc4] inconsistent lock state
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Date: Tue, 17 Dec 2013 10:59:41 -0800
In-Reply-To: <52B09446.7060809@t-online.de>
References: <52B09446.7060809@t-online.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 19:13 +0100, Knut Petersen wrote:
> Hi Linus / everybody!
> 
> Booting openSuSE 13.1 with kernel 3.13.0-rc4 triggers the attached
> warning.
> 
> cu,
>   Knut
> 
> 

Following patch should solve the issue.

http://patchwork.ozlabs.org/patch/301382/

Sorry for this ...

Thanks


