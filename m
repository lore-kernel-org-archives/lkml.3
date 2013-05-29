Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935283Ab3E2WMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:12:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228Ab3E2WMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:12:01 -0400
Date: Wed, 29 May 2013 15:11:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Remove unused /dev/oldmem interface
Message-Id: <20130529151159.2f1d6b5092c58b61724bee7c@linux-foundation.org>
In-Reply-To: <51A4C926.2040701@zytor.com>
References: <51A02E50.5020507@gmail.com>
	<87mwri8wwu.fsf@xmission.com>
	<20130528143756.GD7088@redhat.com>
	<51A4C926.2040701@zytor.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013 08:11:34 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 05/28/2013 07:37 AM, Vivek Goyal wrote:
> > 
> > Eric,
> > 
> > Should we schedule the removal of this interface after 1-2 releases
> > and give a warning once if anybody opens /dev/oldmem and tell them
> > to use /proc/vmcore instead? 
> > 
> > I am kind of inclined towards warning approarch. If there is any xyz
> > /dev/oldmem user in the wild out there, he/she atleast gets a chance to
> > migrate to /proc/vmcore.
> > 
> 
> This has been discussed ad nauseam at the Kernel Summit.  It doesn't work.
> 

Who said that and what was their evidence?  Giving users (especially
the more technical ones) several months warning is eminently sensible.

Although it doesn't appear to be necessary in this case.
