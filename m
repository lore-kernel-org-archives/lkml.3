Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3FYVwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:52:51 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:44699 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3FYVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:52:50 -0400
Date: Wed, 26 Jun 2013 01:52:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Expose /proc/<pid>/task/<tid>/children
 unconditionally
Message-ID: <20130625215247.GC1726@moon>
References: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net>
 <20130625201602.GB1726@moon>
 <20130625201705.GA15966@redhat.com>
 <CALCETrVxm2wHvLgexG6fZO+h1rNHC_qDCv6B+4XuANHgSQU4iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVxm2wHvLgexG6fZO+h1rNHC_qDCv6B+4XuANHgSQU4iw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 02:36:31PM -0700, Andy Lutomirski wrote:
> On Tue, Jun 25, 2013 at 1:17 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 06/26, Cyrill Gorcunov wrote:
> >>
> >> On Tue, Jun 25, 2013 at 12:51:45PM -0700, Andy Lutomirski wrote:
> >> > This is currently only available if CONFIG_CHECKPOINT_RESTORE, which
> >> > is hidden under CONFIG_EXPERT.  It's generally useful functionality,
> >> > though, so expose it unconditionally.
> >> >
> >> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> >> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
> >
> > I didn't see the patch but I guess it is trivial and I agree with intent ;)
> 
> The patch works, but "children" is only listed under task/<tid>, not
> under /proc/<pid>.  Is that intentional?  Fixing it would be a
> one-liner.

Yeah, it's intentional. Here some explanations from Oleg (check out
the whole thread, it's not that big https://lkml.org/lkml/2011/12/9/220)
in short this might require some more code, but i'll re-check tomorrow.
