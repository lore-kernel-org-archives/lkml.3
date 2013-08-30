Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3H3Mxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3H3Mxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:53:38 -0400
Date: Fri, 30 Aug 2013 13:50:14 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: dm-devel@redhat.com, gregkh@linuxfoundation.org, mpatocka@redhat.com,
        linux-kernel@vger.kernel.org, agk@redhat.com,
        kernelnewbies@kernelnewbies.org
Subject: Re: [dm-devel] [RFC] dm-lc: plan to go to staging
Message-ID: <20130830125014.GD12181@agk-dp.fab.redhat.com>
Mail-Followup-To: Akira Hayakawa <ruby.wktk@gmail.com>, dm-devel@redhat.com,
	gregkh@linuxfoundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, agk@redhat.com,
	kernelnewbies@kernelnewbies.org
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com> <20130829033023.GH4872@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1308291043410.20142@file01.intranet.prod.int.rdu2.redhat.com> <52209119.3070907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52209119.3070907@gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 09:33:29PM +0900, Akira Hayakawa wrote:
> I have three candidates on my mind.
> I am thinking of removing the dm- prefix as bcache and enhanceio do.
 
Yes, that's fine for the general way of referring to this.
(Within the codebase, the filename and module name would still need the
prefix: we use this for auto-module loading, function name/error message
scoping etc.)

>    a) It writes in-coming writes in log-structured manner.
>    b) It is extremely fast in write.
>    c) It is caching software.

Another candidate: 'lcache' - contrast with 'bcache
 
> 3) writeboost or wboost
> Concentrating on the characteristic b)
> but doesn't mention cache.

I quite like that option.

Alasdair

