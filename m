Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3GTCHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 22:07:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3GTCHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 22:07:44 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=-YTRjD98RaAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=q1GZVgvxtRzfWfVPF_4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374286063.3356.59.camel@gandalf.local.home>
Subject: Re: [ 00/72] 3.10.2-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: John <da_audiophile@yahoo.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 19 Jul 2013 22:07:43 -0400
In-Reply-To: <1374284610.69280.YahooMailNeo@web140002.mail.bf1.yahoo.com>
References: <1374284610.69280.YahooMailNeo@web140002.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't strip Cc's. This mailing list gets over 600 emails a day.
Nobody bothers to read all emails. By stripping the Cc's your message
will likely be ignored.

Luckily for you, I filter for stable releases.

On Fri, 2013-07-19 at 18:43 -0700, John wrote:
> Two hunks fail for me patching source from linux-3.10.tar.xz as shown:
> 
> patching file Documentation/parisc/registers
> patching file Makefile
> Hunk #1 FAILED at 1.
> 1 out of 1 hunk FAILED -- saving rejects to file Makefile.rej

You need to apply it against 3.10.1, not 3.10.

-- Steve


