Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbbANPzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:55:33 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:33778 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbANPzc (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 14 Jan 2015 10:55:32 -0500
Message-ID: <1421250926.2258.14.camel@stgolabs.net>
Subject: Re: [PATCH 6/8] locking/mcs: Better differentiate between mcs
 variants
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2015 07:55:26 -0800
In-Reply-To: <20150114141356.GA12084@gmail.com>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
	 <1419757883-4423-7-git-send-email-dave@stgolabs.net>
	 <20150114141356.GA12084@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> x86 defconfig produces:
> 
>   kernel/locking/mcs_spinlock.h:81:2: error: implicit declaration of function ‘ASSIGN_ONCE’ [-Werror=implicit-function-declaration]
> 
> Also, this patch should really be split into three separate (and 
> tested) patches.

These patches were tested, the failure is because the ASSIGN_ONCE
function was renamed only yesterday (see
43239cbe79fc369f5d2160bd7f69e28b5c50a58c).

Thanks,
Davidlohr

