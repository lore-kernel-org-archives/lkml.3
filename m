Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaI2XaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:30:01 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53558 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751028AbaI2X37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:29:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] ACPI / SBS: fix sparse warning
Date: Tue, 30 Sep 2014 01:49:55 +0200
Message-ID: <2310110.VDaAnN6nFV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411929887-2440-1-git-send-email-fabf@skynet.be>
References: <1411929887-2440-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 28, 2014 08:44:47 PM Fabian Frederick wrote:
> Adding parentheses around expression to avoid:
> drivers/acpi/sbs.c:444:28: warning: dubious: !x & y
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

I was faster: https://patchwork.kernel.org/patch/4990671/


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
