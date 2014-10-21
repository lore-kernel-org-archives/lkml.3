Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbaJUWf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:35:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933390AbaJUWf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:35:58 -0400
From: Paul Moore <pmoore@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org, aviro@redhat.com
Subject: Re: [PATCH V5 0/5] audit by executable name
Date: Tue, 21 Oct 2014 18:35:57 -0400
Message-ID: <13346524.UcV0TUOQcF@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1413929992.30946.59.camel@localhost>
References: <cover.1412303728.git.rgb@redhat.com> <3623738.X9Kq6ePK5C@sifl> <1413929992.30946.59.camel@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 06:19:52 PM Eric Paris wrote:
> On Tue, 2014-10-21 at 17:56 -0400, Paul Moore wrote:
> > * Change the audit_status.version field comment in
> > include/uapi/linux/audit.h to "/* audit functionality bitmap */", or
> > similar.  We can't really change the structure now, but the comment is
> > fair game.
> 
> Trying to think how to do things with a #define so you can rename,
> "version" is pretty darn generic to pre-process.  You could make it a
> union, so userspace code and use a sane name....

Yeah, I thought about suggesting the #define approach but figured that might 
just be me worrying about the color of the paint ... okay, Richard, why don't 
you go ahead and change the version field name and put in a #define for 
compatibility.

> > Can anyone think of anything else that might be affected by this?
> 
> No one uses this stuff, just change it.

Yes, but I feel like I need to at least ask the question; how much attention I 
pay to the answers is something else ...

-- 
paul moore
security and virtualization @ redhat

