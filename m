Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab3BZOR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:17:27 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:38469 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab3BZORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:17:25 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1302261427020.14180@twin.jikos.cz>
References: <87ppzo79in.fsf@mid.deneb.enyo.de> <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org> <18738.1361836265@warthog.procyon.org.uk>
 <alpine.LRH.2.00.1302261427020.14180@twin.jikos.cz>
From: Raymond Jennings <shentino@gmail.com>
Date: Tue, 26 Feb 2013 06:16:44 -0800
Message-ID: <CAGDaZ_q_8GN96ZgQrO1TMEen=_q=HW8HUAv3GMinBbv87XDzaQ@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My two cents on this subject btw is that anything to do with
Microsoft's intentions or plans is an issue of policy that belongs
entirely in userspace.

"mechanism, not policy"

Besides, what do modules have to do with this if we're talking about
UEFI?  Doesn't the kernel have to be loaded before modules are even an
issue?

Pardon me for being lost, just tyring to follow this.
