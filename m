Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3GBWnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab3GBWnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:43:10 -0400
Date: Wed, 3 Jul 2013 00:37:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Lukas Czerner <lczerner@redhat.com>,
        Samuel Ortiz <samuel@sortiz.org>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Ralf Baechle <ralf@linux-mips.org>, Valdis.Kletnieks@vt.edu,
        linux-mm <linux-mm@kvack.org>
Subject: Re: linux-next: Tree for Jun 28 [ BISECTED: rsyslog/imklog: High
	CPU usage ]
Message-ID: <20130702223714.GA28048@redhat.com>
References: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com> <20130630181945.GA5171@redhat.com> <CA+icZUWLUSg-Sfd9FHXs8Amz+-s6vs_VOJsQpUSa9+fYM8XyNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWLUSg-Sfd9FHXs8Amz+-s6vs_VOJsQpUSa9+fYM8XyNQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sedat,

On 07/02, Sedat Dilek wrote:
>
> did you made a cleaned-up version?
> AFAICS v3, I read that on linux-mm ML, sorry if I ask here in this thread.

Yes, I am going to send v3 with this fix + another minor change.
Sorry for delay, I was distracted, will try tomorrow.

Besides, I think Andrew and Stephen need a rest before I try to
break wait.h or the third time.

Oleg.

