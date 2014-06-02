Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaFBRjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:39:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53740 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaFBRji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:39:38 -0400
Message-ID: <538CB68A.6030408@zytor.com>
Date: Mon, 02 Jun 2014 10:38:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>, Jason Low <jason.low2@hp.com>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, chegu_vinod@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>  <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com> <1401727810.7440.34.camel@j-VirtualBox> <538CB389.5080108@hp.com>
In-Reply-To: <538CB389.5080108@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 10:25 AM, Waiman Long wrote:
> 
> Doing an xchg is a very expensive operation compared with ACCESS_ONCE. I
> will not suggest doing that to make it right for PA-RISC at the expense
> of performance in other architectures.
> 

And of course, this gets into the toxic question: what are reasonable
minimum requirements for Linux?  How far do we need to stretch to
support niche architectures which have very small (Linux) userbases?

	-hpa


