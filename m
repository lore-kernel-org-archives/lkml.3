Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab3EGADY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:03:24 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50979 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934072Ab3EGADT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:03:19 -0400
Date: Tue, 7 May 2013 02:03:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] softirq: use _RET_IP_
Message-ID: <20130507000314.GB1703@somewhere>
References: <1367347569.1784.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367347569.1784.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 11:46:09AM -0700, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr.bueso@hp.com>
> 
> Use the already defined macro to pass the function return address.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.
