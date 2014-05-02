Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaEBTCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:02:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:13231 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751784AbaEBTCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:02:15 -0400
Date: Fri, 2 May 2014 15:02:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/8] ftrace: make CALLER_ADDRx macros more generic
Message-ID: <20140502150206.4afa9b1a@gandalf.local.home>
In-Reply-To: <20140502181348.GD14645@arm.com>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-2-git-send-email-takahiro.akashi@linaro.org>
	<20140502181348.GD14645@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014 19:13:48 +0100
Will Deacon <will.deacon@arm.com> wrote:

> Hi Akashi,
> 
> On Wed, Apr 30, 2014 at 10:54:29AM +0100, AKASHI Takahiro wrote:
> > Most archs with HAVE_ARCH_CALLER_ADDR have the almost same definitions
> > of CALLER_ADDRx(n), and so put them into linux/ftrace.h.
> > 
> > Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> > ---
> >  arch/arm/include/asm/ftrace.h      |   10 +---------
> >  arch/blackfin/include/asm/ftrace.h |   11 +----------
> >  arch/parisc/include/asm/ftrace.h   |   10 +---------
> >  arch/sh/include/asm/ftrace.h       |   10 +---------
> >  arch/xtensa/include/asm/ftrace.h   |   14 ++++----------
> >  include/linux/ftrace.h             |   34 ++++++++++++++++++----------------
> >  6 files changed, 26 insertions(+), 63 deletions(-)
> 
> This one looks a bit too widespread to be merged via the arm64 tree. I
> wonder if the ftrace maintainers would consider taking it as a cleanup?
> 

I actually was the one to recommend this approach. But I have some
small comments to the patch. I'll reply directly to the patch with them.

-- Steve
