Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaHDO53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaHDO52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:57:28 -0400
Date: Mon, 4 Aug 2014 16:55:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 0/5] (Was: procfs: silence lockdep warning about read
	vs. exec seq_file)
Message-ID: <20140804145503.GA24471@redhat.com>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name> <20140803164452.GA14626@redhat.com> <20140803211843.GA13330@redhat.com> <20140804092043.GA13940@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804092043.GA13940@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Kirill A. Shutemov wrote:
>
> On Sun, Aug 03, 2014 at 11:18:43PM +0200, Oleg Nesterov wrote:
> >
> > Absolutely untested, only for review.
> >
> > What do you all think?
>
> Look good. And works for me.

OK, thanks Kirill and Cyrill ;)

I'll try to recheck, update the changelogs and resend after the testing,
hopefully tomorrow.

> task_nommu.c need to be covered too, I believe.

Yes, I know, thanks. I'd prefer to make a separate patch or two, simply
because I can't test the changes in nommu. The only question is how much
should I try to avoid the copy-and-paste... probably I won't try at all.

Oleg.

