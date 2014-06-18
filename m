Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaFRR1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:27:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:55936 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751366AbaFRR1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:27:13 -0400
Date: Wed, 18 Jun 2014 13:27:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [tracing] 939c7a4f04f: -46.4% cpuidle.C3-IVT.time
Message-ID: <20140618132708.38f1a7fc@gandalf.local.home>
In-Reply-To: <53A10460.1040705@intel.com>
References: <53A10460.1040705@intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 11:15:44 +0800
Jet Chen <jet.chen@intel.com> wrote:

> Hi Yoshihiro,
> 
> FYI, we noticed the below changes on
> 
> commit 939c7a4f04fcd2162109744e8bf88194948a6e65 ("tracing: Introduce saved_cmdlines_size file")
> 
> test case: brickland3/aim7/3000-brk_test

Um, do these tests run with tracing enabled and on? If not, the code in
the above mentioned commit is never executed.

Something may be whacky with your bisect.

-- Steve

> 
> beba4bb096201ce  939c7a4f04fcd2162109744e8
> ---------------  -------------------------

