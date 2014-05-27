Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaE0Swl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:52:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56763 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbaE0Swk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:52:40 -0400
Date: Tue, 27 May 2014 19:49:40 +0100
From: Will Deacon <will.deacon@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: [for-next][PATCH] ftrace: Make CALLER_ADDRx macros more generic
Message-ID: <20140527184940.GA26035@arm.com>
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862353-28963-7-git-send-email-takahiro.akashi@linaro.org>
 <20140416135217.GF1001@arm.com>
 <535E3040.7090402@linaro.org>
 <20140527091019.54a8d2d6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527091019.54a8d2d6@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:10:19PM +0100, Steven Rostedt wrote:
> Will,
> 
> I made a separate branch called ftrace/arm64 as shown below. You can
> pull that branch to base the rest of Akashi-san's patches on top of it.
> The branch is based on top of v3.15-rc5.

Thanks Steve, I'll pull that in.

Akashi: please can you re-send your series, based on the branch below and
including the acks/reviewed-by tags you got for v6 of the patches?

Cheers,

Will

>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> ftrace/arm64
> 
> Head SHA1: eed542d6962ba33a689b4007a389f466e407bd74
