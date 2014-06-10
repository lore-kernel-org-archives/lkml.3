Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaFJPmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:42:54 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:47414 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFJPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:42:52 -0400
MIME-Version: 1.0
In-Reply-To: <1402404640.4456.4.camel@flatline.rdu.redhat.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
	<20140609223057.GB18475@kroah.com>
	<CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
	<CA+55aFwmajRnDOiBmZQf8rpVE-HigsDYy9oy-TsWLzn-vdyF+Q@mail.gmail.com>
	<CALCETrXBSd4qKJE+yVp0YTPdrCDSfGf_SOxaZFgQpULg1bF3aA@mail.gmail.com>
	<CA+55aFxAj5nA-fqTRE0Cotwxywf5LNCb-NnpWCHxZTn2GF3C4g@mail.gmail.com>
	<1402404640.4456.4.camel@flatline.rdu.redhat.com>
Date: Tue, 10 Jun 2014 08:42:52 -0700
X-Google-Sender-Auth: wf01dXmHBxEvE2IH5iDNBvhATLQ
Message-ID: <CA+55aFxzrJ6vBEJcByUO2+auO7k8AMJPTYH8t9K0xx=uxoqPOQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds checking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 5:50 AM, Eric Paris <eparis@redhat.com> wrote:
>
> No, it's good to blame me.  I was trying to deal with it as fast as I
> could since I was already trying to ignore my computer before I got
> married last weekend and took the last week off.  I realized when I got
> back yesterday you hadn't picked it up and it was on my list of things
> to try to handle today.  I think both 1 and 2 are good to be applied to
> your tree.  Although only #1 is really an absolutely critical issue.

Ok, I'll take your patch-series rather than the recent pull from Andy,
and pick up #2 that way too.

I'll just take them from emails - it's not like I have to wait for a
pull from you. It's just that I don't want to take them from emails
_and_ then get them in a pull from you, which is why I tend to want to
get explicit "please apply these directly" notification.

                Linus
