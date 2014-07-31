Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaGaA4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:56:45 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:55683 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaGaA4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:56:44 -0400
Message-ID: <1406768201.2304.1.camel@j-VirtualBox>
Subject: Re: [PATCH -tip v2 4/7] locking/mutex: Refactor optimistic spinning
 code
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 17:56:41 -0700
In-Reply-To: <1406752916-3341-4-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-1-git-send-email-davidlohr@hp.com>
	 <1406752916-3341-4-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 13:41 -0700, Davidlohr Bueso wrote:
> When we fail to acquire the mutex in the fastpath, we end up calling
> __mutex_lock_common(). A *lot* goes on in this function. Move out the
> optimistic spinning code into mutex_optimistic_spin() and simplify
> the former a bit. Furthermore, this is similar to what we have in
> rwsems. No logical changes.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Acked-by: Jason Low <jason.low2@hp.com>

