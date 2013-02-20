Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3BTXOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:14:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3BTXOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:14:20 -0500
Date: Wed, 20 Feb 2013 15:14:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] coredump: fix the ancient signal problems
Message-Id: <20130220151418.bb91dc4e.akpm@linux-foundation.org>
In-Reply-To: <20130220223226.GA16194@redhat.com>
References: <20130217191819.GA21778@redhat.com>
	<CACBanvoxwb341yO_hoJDDqZf9htgY2NNiOw0LfYj3TUe9zM5+w@mail.gmail.com>
	<20130220223226.GA16194@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 23:32:26 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 02/19, Mandeep Singh Baines wrote:
> >
> > For the whole series:
> >
> > Tested-by: Mandeep Singh Baines <msb@chromium.org>
> 
> Oh, thanks a lot Mandeep.
> 
> I tried to test it too, seems to work.
> 
> Andrew, could you take it? We will make more fixes on top.
> 

Did that, but the timing and somewhat tentative nature of the changes
makes me think "3.10-rc1".  Is that a problem?
