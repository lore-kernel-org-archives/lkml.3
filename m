Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3AZN0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:26:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3AZN0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:26:19 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=aToonZMXCzYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=uAnHXTU4GzMA:10 a=jmhgrvTM-liwyfJdCjAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359206776.17639.1.camel@gandalf.local.home>
Subject: Re: [PATCH] regulators/db8500: Fix compile failure for
 drivers/regulator/dbx500-prcmu.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Date: Sat, 26 Jan 2013 08:26:16 -0500
In-Reply-To: <20130126073121.GO10580@opensource.wolfsonmicro.com>
References: <1359041366.21576.146.camel@gandalf.local.home>
	 <20130126073121.GO10580@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-26 at 15:31 +0800, Mark Brown wrote:

> Applied, thanks.  Please use subject lines appropriate for the subsystem
> (I see I let the original one through).

Heh, when making patches for other subsystems, I look at the subject of
the patch that broke to determine what to use.

-- Steve


