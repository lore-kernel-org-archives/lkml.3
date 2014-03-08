Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaCHB10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:27:26 -0500
Received: from r00tworld.com ([212.85.137.150]:53317 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbaCHB1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:27:22 -0500
From: "PaX Team" <pageexec@freemail.hu>
To: khali@linux-fr.org, rostedt@goodmis.org,
        Behan Webster <behanw@converseincode.com>
Date: Sat, 08 Mar 2014 02:25:48 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] module: LLVMLinux: Remove unused function warning from __param_check macro
Reply-to: pageexec@freemail.hu
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        Mark Charlebois <charlebm@gmail.com>
Message-ID: <531A719C.19855.32E9C505@pageexec.freemail.hu>
In-reply-to: <531A69E0.3000407@converseincode.com>
References: <1394219327-5591-1-git-send-email-behanw@converseincode.com>, <531A4E84.9996.3260AF06@pageexec.freemail.hu>, <531A69E0.3000407@converseincode.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Sat, 08 Mar 2014 02:25:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Mar 2014 at 16:52, Behan Webster wrote:

> On 03/07/14 14:56, PaX Team wrote:
> > why can't you have the attr on the definition itself:
> >
> > static inline __unused type *__check_##name(void) { return(p); }
> >
> >
> >
> "__unused" isn't defined anywhere I can find, except in:
> 
> src/linux/drivers/net/ethernet/amd/declance.c:#define __unused 
> __attribute__ ((unused))

oh i forgot about that, you'd of course place this #define
into the appropriate compiler*.h files so that other code
can make use of it in the future as well ;).

