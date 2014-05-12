Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbaELRXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:23:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:16800 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752204AbaELRXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:23:53 -0400
Date: Mon, 12 May 2014 13:23:51 -0400
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
Message-ID: <20140512132351.5f5d8b48@gandalf.local.home>
In-Reply-To: <20140512161246.GC4880@arm.com>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-2-git-send-email-takahiro.akashi@linaro.org>
	<20140502151957.6978d870@gandalf.local.home>
	<20140512155811.GB4880@arm.com>
	<20140512120535.041030dd@gandalf.local.home>
	<20140512161246.GC4880@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 17:12:46 +0100
Will Deacon <will.deacon@arm.com> wrote:


> If you point us at the branch and promise not to rebase it, that would be
> fantastic.

I will when I get the patch(es) :-) and run it through all my tests.

-- Steve

