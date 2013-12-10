Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3LJTPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:15:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3LJTPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:15:03 -0500
Date: Tue, 10 Dec 2013 14:14:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Rob Landley <rob@landley.net>, Eric Biederman <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        kexec@lists.infradead.org
Subject: Re: [PATCH v2] kexec: add sysctl to disable kexec
Message-ID: <20131210191409.GE13909@redhat.com>
References: <20131210001620.GA7938@www.outflux.net>
 <52A66190.9060907@zytor.com>
 <CAGXu5jKkCNWQKH-Ozm72C3aY_NBzRdNo2GmqKbVVJds5xs=SXg@mail.gmail.com>
 <20131210143540.GA13909@redhat.com>
 <f4fbae55-7d7b-400d-b50f-258002371368@email.android.com>
 <20131210183352.GD13909@redhat.com>
 <52A76348.5080803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A76348.5080803@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:54:00AM -0800, H. Peter Anvin wrote:
> On 12/10/2013 10:33 AM, Vivek Goyal wrote:
> > On Tue, Dec 10, 2013 at 08:32:38AM -0800, H. Peter Anvin wrote:
> >> Of course it isn't.
> > 
> > I am not sure what are you trying to say. This is too brief.
> > 
> > Thanks
> > Vivek
> > 
> 
> Of course it is not sufficient.  Once you can get arbitrary code into
> kernel space (CPL 0) you can do anything, and "disabling jump back" is
> just a speed bump.

Agreed that disabling jump back is only a speed bump.

Kees, so how would be use this knob?

- If I put it in some init script, then root will permission to modify
  and remove it.

- Can one specify sysctl parameters on command line? If yes, then one
  can disable this using kernel command line and in that case kdump will
  be disabled too.

Thanks
Vivek
