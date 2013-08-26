Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3HZVtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:49:46 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42111 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3HZVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:49:45 -0400
Date: Tue, 27 Aug 2013 01:49:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: unused swap offset / bad page map.
Message-ID: <20130826214940.GA7416@moon>
References: <20130823032127.GA5098@redhat.com>
 <CAJd=RBArkh3sKVoOJUZBLngXtJubjx4-a3G6s7Tn0N=Pr1gU4g@mail.gmail.com>
 <20130823035344.GB5098@redhat.com>
 <CAJd=RBBtY-nJfo9nzG5gtgcvB2bz+sxpK5kX33o1sLeLhvEU1Q@mail.gmail.com>
 <20130826190757.GB27768@redhat.com>
 <20130826201846.GA23724@moon>
 <20130826203702.GA15407@redhat.com>
 <20130826204203.GB23724@moon>
 <20130826213754.GN3814@moon>
 <20130826214244.GA21146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826214244.GA21146@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:42:44PM -0400, Dave Jones wrote:
> 
> Yeah, for reproducing this bug, I'd stick to running it as a user, without --dangerous.
> you might still hit a few fairly-easy to trigger warn-on/printks. I run with
> this applied: http://paste.fedoraproject.org/34960/55323613/raw/ to make things
> a little less noisy.

Ah, thanks, pulling it in. Btw, have you seen this problem earlier than -rc4 at all?
