Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaCNU04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:26:56 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:40737 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaCNU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:26:55 -0400
Message-ID: <1394828801.2931.7.camel@j-VirtualBox>
Subject: Re: [locking/mutexes] WARNING: CPU: 1 PID: 77 at
 kernel/locking/mutex-debug.c:82 debug_mutex_unlock()
From: Jason Low <jason.low2@hp.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Mar 2014 13:26:41 -0700
In-Reply-To: <532358F7.4090705@gmail.com>
References: <20140313012744.GA7714@localhost>
	 <1394675197.2107.3.camel@j-VirtualBox> <532358F7.4090705@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-14 at 15:31 -0400, Sasha Levin wrote:
> On 03/12/2014 09:46 PM, Jason Low wrote:
> > Hi Fengguang,
> >
> > Can you try out this patch?
> >
> > https://lkml.org/lkml/2014/3/12/243
> 
> Hi Jason,
> 
> It fixes the problem for me.

Hi Sasha,

Great, thanks for letting us know.


