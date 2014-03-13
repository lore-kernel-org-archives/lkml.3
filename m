Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaCMBqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:46:46 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:51982 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaCMBqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:46:45 -0400
Message-ID: <1394675197.2107.3.camel@j-VirtualBox>
Subject: Re: [locking/mutexes] WARNING: CPU: 1 PID: 77 at
 kernel/locking/mutex-debug.c:82 debug_mutex_unlock()
From: Jason Low <jason.low2@hp.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Mar 2014 18:46:37 -0700
In-Reply-To: <20140313012744.GA7714@localhost>
References: <20140313012744.GA7714@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

Can you try out this patch?

https://lkml.org/lkml/2014/3/12/243

