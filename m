Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab3CLC24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:28:56 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:54439 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3CLC2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:28:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAJtEV7ZsOd=c6_+A3W+NYBtrWAUPH7NrVEk-J+_+ZgoJQTBZVg@mail.gmail.com>
References: <CAJtEV7ZsOd=c6_+A3W+NYBtrWAUPH7NrVEk-J+_+ZgoJQTBZVg@mail.gmail.com>
Date: Tue, 12 Mar 2013 10:28:53 +0800
Message-ID: <CAJtEV7YfgcxuEAj+a8SbNmsoMHaEgY1RQ1RoR=8nAi4=8qwT_w@mail.gmail.com>
Subject: Re: Bug involving dynamic_debug and '-p' modifier
From: Andrew Cooks <acooks@gmail.com>
To: Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 9:14 AM, Andrew Cooks <acooks@gmail.com> wrote:
> Hi Jason
>
> When I specify a '-p' modifier in the dynamic debug options in the
> kernel command line, I get a kernel panic during boot. The panic
> happens after userspace starts doing graphical stuff, but I haven't
> been able to pinpoint exactly what.
>
> If I use '=_' instead of '-p', or boot to a recovery mode, or change
> the modifier after booting using debugfs, the panic doesn't occur. For
> example, booting to runlevel 3 with '=_', then flipping the same
> modifier to first to '+p' and then to '-p', before starting X does not
> result in a panic.
>
> Booting to runlevel 3 (or even 1!), with '-p' results in a panic, but
> 'rdshell' is OK.
>
> I also tried the Red Hat kernel (just because it's installed - I
> haven't figured out how to tell the package manager that I don't want
> a kernel). This also panics, but it says that '-p' is not supported.
>
> Please let me know if you need me to do any other tests.
>
> '-p', panic: http://pastebin.com/8yAcBQdY
> '-p', rdshell, no panic: http://pastebin.com/Hi2a7BZA
>
> --
> a.

Jason's mail bounced, so redirecting to Jim Cromie, who made the most
recent significant changes to dynamic_debug...
