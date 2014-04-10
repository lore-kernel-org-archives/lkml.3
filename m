Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161190AbaDJVvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 17:51:53 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:28772 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaDJVvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 17:51:52 -0400
Message-ID: <1397166711.2608.56.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 03/15] ipc:sem.c #include <linux/uaccess.h>
From: Davidlohr Bueso <davidlohr@hp.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Thu, 10 Apr 2014 14:51:51 -0700
In-Reply-To: <1397166544.2608.55.camel@buesod1.americas.hpqcorp.net>
References: <1397155525-6420-1-git-send-email-paulmcquad@gmail.com>
	 <1397166544.2608.55.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 14:49 -0700, Davidlohr Bueso wrote:
> On Thu, 2014-04-10 at 19:45 +0100, Paul McQuade wrote:
> > WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> 
> Nit: the subject should be less code and more text, something like "do
> not include asm uaccess directly" or "replace <asm/uaccess.h> by
> <linux/uaccess.h>"
> 
> Curious, how are you seeing these warnings?
> 
> Also, while at it we should probably get rid of the rest in ipc/:
> 
> compat.c:#include <asm/uaccess.h>
> compat_mq.c:#include <asm/uaccess.h>
> msg.c:#include <asm/uaccess.h>
> sem.c:#include <asm/uaccess.h>
> shm.c:#include <asm/uaccess.h>

*sigh* you did but didn't maintain the CCs. It would make a lot more
sense to keep it in the same patch.


