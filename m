Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3GKWO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:14:57 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39340 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3GKWOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:14:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
References: <20130711214830.611455274@linuxfoundation.org>
Date: Thu, 11 Jul 2013 18:14:54 -0400
Message-ID: <CA+5PVA6xk6dR51=b6EDHTbP8XGD=tmwbHz-+dW=1_8fofq47hw@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Josh Boyer <jwboyer@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 6:01 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> <rant>
>   I'm sitting on top of over 170 more patches that have been marked for
>   the stable releases right now that are not included in this set of
>   releases.  The fact that there are this many patches for stable stuff
>   that are waiting to be merged through the main -rc1 merge window cycle
>   is worrying to me.

Very much agreed.

>   Why are subsystem maintainers holding on to fixes that are
>   _supposedly_ affecting all users?  I mean, 21 powerpc core changes
>   that I don't see until a -rc1 merge?  It's as if developers don't
>   expect people to use a .0 release and are relying on me to get the
>   fixes they have burried in their trees out to users.  That's not that
>   nice.  6 "core" iscsi-target fixes?  That's the sign of either a
>   broken subsystem maintainer, or a lack of understanding what the
>   normal -rc kernel releases are supposed to be for.

This is the kind of stuff I was alluding to on the ksummit-discuss
list.  I was beginning to think we were the only ones noticing so I'm
glad you're speaking up.

>   So, I've picked through the patches and dug out only those that I've
>   "guessed" at being more important than others for the 3.10.1 release.
>   I'll get to the rest of these after 3.11-rc1 is out, and eventually
>   they will make it into the stable releases, but I am going to be much
>   more strict as to what is being added (carriage return changes for
>   debug messages, really ACPI developers?)

That's very much appreciated, Greg.  Thanks.

josh
