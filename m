Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3LMOgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:36:22 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51198 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3LMOgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:36:19 -0500
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <CA+5PVA4fcf526u=AF4TwQP3xdajV-qE5Jn6NKG2mme=YK8nvhw@mail.gmail.com>
References: <alpine.LRH.2.02.1312131351140.31472@tundra.namei.org>
	<CA+5PVA4fcf526u=AF4TwQP3xdajV-qE5Jn6NKG2mme=YK8nvhw@mail.gmail.com>
Date: Fri, 13 Dec 2013 09:36:18 -0500
Message-ID: <CAHC9VhRHeukZ0e_RYDFuh_eQThZnNtNnsUgtB5S+VjHjAXcCKQ@mail.gmail.com>
Subject: Re: [GIT] SELinux fixes
From: Paul Moore <paul@paul-moore.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 9:02 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> Should probably figure out which path to take on this one soon:
>
> http://thread.gmane.org/gmane.linux.kernel/1611662
>
> A revert might be the easiest for now.

Yeah, I followed the discussion you and Eric were having earlier this
week; I was hoping that you guys would be able to arrive at a fix as I
would much prefer to fix the issue and not have to revert.

If I don't see something from Eric within the next couple of hours
I'll go ahead and do the revert.

-Paul

-- 
paul moore
www.paul-moore.com
