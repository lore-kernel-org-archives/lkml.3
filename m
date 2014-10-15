Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaJOGcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:32:51 -0400
Received: from ozlabs.org ([103.22.144.67]:56066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaJOGcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:32:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, tiwai@suse.de, tj@kernel.org,
        arjan@linux.intel.com
Cc: teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, mcgrof@suse.com, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr, Christoph Hellwig <hch@infradead.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Ewan Milne <emilne@redhat.com>, Jean Delvare <jdelvare@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/7] module: add extra argument for parse_params() callback
In-Reply-To: <1412372683-2003-3-git-send-email-mcgrof@do-not-panic.com>
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com> <1412372683-2003-3-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Oct 2014 16:05:00 +1030
Message-ID: <87egu9c2uz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> This adds an extra argument onto parse_params() to be used
> as a way to make the unused callback a bit more useful and
> generic by allowing the caller to pass on a data structure
> of its choice. An example use case is to allow us to easily
> make module parameters for every module which we will do
> next.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
