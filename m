Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3BWUXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 15:23:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959Ab3BWUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 15:23:06 -0500
Date: Sat, 23 Feb 2013 21:21:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] coredump: fix the ancient signal problems
Message-ID: <20130223202125.GA13646@redhat.com>
References: <20130217191819.GA21778@redhat.com> <CACBanvoxwb341yO_hoJDDqZf9htgY2NNiOw0LfYj3TUe9zM5+w@mail.gmail.com> <20130220223226.GA16194@redhat.com> <20130220151418.bb91dc4e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220151418.bb91dc4e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Andrew Morton wrote:
>
> On Wed, 20 Feb 2013 23:32:26 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Andrew, could you take it? We will make more fixes on top.
>
> Did that, but the timing and somewhat tentative nature of the changes
> makes me think "3.10-rc1".

Oh, yes, I will sleep much better if these changes get more testing
in -mm, I do not think this is 3.9 material.

Oleg.

