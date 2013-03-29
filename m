Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab3C2V2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:28:54 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51674 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab3C2V2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:28:53 -0400
MIME-Version: 1.0
In-Reply-To: <1364589989.13783.2.camel@buesod1.americas.hpqcorp.net>
References: <1364589989.13783.2.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 29 Mar 2013 14:28:52 -0700
Message-ID: <CANN689H=Ktst2MHgK5av3gSeeO4bdQpLEEMYuM37QZJbqKtyoA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rbtree_test: add extra rbtree integrity check
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 1:46 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> Account for the rbtree having  2**bh(v)-1 internal nodes.
>
> While this can be seen as a consequence of other checks, Michel states
> that it nicely sums up what the other properties are for.
>
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
