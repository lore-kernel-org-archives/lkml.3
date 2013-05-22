Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3EVNws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:52:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab3EVNwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:52:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, shli@kernel.org,
        riel@redhat.com, lwoodman@redhat.com, mgorman@suse.de
Subject: Re: [RFC PATCH 02/02] swapon: add "cluster-discard" support
References: <cover.1369092449.git.aquini@redhat.com>
	<398ace0dd3ca1283372b3aad3fceeee59f6897d7.1369084886.git.aquini@redhat.com>
	<519AC7B3.5060902@gmail.com> <20130521102648.GB11774@x2.net.home>
	<519BD640.4040102@gmail.com>
	<20130521211300.GE20178@optiplex.redhat.com>
	<519BEED7.6030605@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 22 May 2013 09:52:34 -0400
In-Reply-To: <519BEED7.6030605@gmail.com> (KOSAKI Motohiro's message of "Tue,
	21 May 2013 18:01:59 -0400")
Message-ID: <x49hahvqfz1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@gmail.com> writes:

>> Instead of reverting and renaming --discard, what about making it accept an
>> optional argument, so we could use --discard (to enable all thing and keep
>> backward compatibility); --discard=cluster & --discard=batch (or whatever we
>> think it should be named). I'll try to sort this approach out if you folks think
>> it's worthwhile. 
>
> Optional argument looks nice, at least to me. 
>
> But hmm.. 
>
> "cluster" and "batch" describes current kernel implementation, not user visible effect. 
> Usually I suggest to pick up a word from man pages because it describe user visible action.
> e.g. --discard=freed-pages or --discard=io or --discard=swapon or --discard=once, etc..
>
> But this is not strong opinion. You can ignore it. I don't think I have good English sense. :-)

I like discard=swapon.  For the fine-grained discards, I don't have a
strong opinion, but I guess I'd lean towards freed-pages.

Cheers,
Jeff
