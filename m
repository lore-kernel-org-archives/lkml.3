Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab3EBM3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab3EBM3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:29:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130502122302.GK7800@kernel.dk>
References: <20130502122302.GK7800@kernel.dk> <1367485129-4423-1-git-send-email-imre.deak@intel.com> <15077.1367490569@warthog.procyon.org.uk> <CAKMK7uGKnK1VL5wNiFJXeBOHypWup8-7hZDLSqvEsbwvxVW5tA@mail.gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: dhowells@redhat.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
Date: Thu, 02 May 2013 13:29:29 +0100
Message-ID: <3620.1367497769@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> wrote:

> IMHO, the change definitely makes sense.

Yeah...  I think I agree.

David
