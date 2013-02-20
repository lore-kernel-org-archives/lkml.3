Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3BTWeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:34:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3BTWeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:34:02 -0500
Date: Wed, 20 Feb 2013 23:32:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] coredump: fix the ancient signal problems
Message-ID: <20130220223226.GA16194@redhat.com>
References: <20130217191819.GA21778@redhat.com> <CACBanvoxwb341yO_hoJDDqZf9htgY2NNiOw0LfYj3TUe9zM5+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvoxwb341yO_hoJDDqZf9htgY2NNiOw0LfYj3TUe9zM5+w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Mandeep Singh Baines wrote:
>
> For the whole series:
>
> Tested-by: Mandeep Singh Baines <msb@chromium.org>

Oh, thanks a lot Mandeep.

I tried to test it too, seems to work.

Andrew, could you take it? We will make more fixes on top.

Oleg.

