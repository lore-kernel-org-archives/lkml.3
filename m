Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaFRAPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:15:48 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:17507 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbaFRAPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:15:47 -0400
Message-ID: <1403050539.4155.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RESEND] shm: shm exit scalability fixes
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jack Miller <millerjo@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Milton Miller II <miltonm@us.ibm.com>, anton@au1.ibm.com
Date: Tue, 17 Jun 2014 17:15:39 -0700
In-Reply-To: <20140617195510.GA22266@toadite.austin.ibm.com>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
	 <1403027312.2464.5.camel@buesod1.americas.hpqcorp.net>
	 <20140617195510.GA22266@toadite.austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 14:55 -0500, Jack Miller wrote:
> Even if this is synthetic, the testcase could also be seen as proof of an
> unprivileged denial of service as an arbitrary user could run bust_shm_exit
> and subsequently start overloading the system.

We have the shmmni limit (and friends) for that.

Thanks,
Davidlohr

