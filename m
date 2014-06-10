Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaFJPsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:48:39 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:47033 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaFJPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxzrJ6vBEJcByUO2+auO7k8AMJPTYH8t9K0xx=uxoqPOQ@mail.gmail.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
	<20140609223057.GB18475@kroah.com>
	<CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
	<CA+55aFwmajRnDOiBmZQf8rpVE-HigsDYy9oy-TsWLzn-vdyF+Q@mail.gmail.com>
	<CALCETrXBSd4qKJE+yVp0YTPdrCDSfGf_SOxaZFgQpULg1bF3aA@mail.gmail.com>
	<CA+55aFxAj5nA-fqTRE0Cotwxywf5LNCb-NnpWCHxZTn2GF3C4g@mail.gmail.com>
	<1402404640.4456.4.camel@flatline.rdu.redhat.com>
	<CA+55aFxzrJ6vBEJcByUO2+auO7k8AMJPTYH8t9K0xx=uxoqPOQ@mail.gmail.com>
Date: Tue, 10 Jun 2014 08:48:37 -0700
X-Google-Sender-Auth: 5IHmCzkFstwsWTm5icgNdt-0gv4
Message-ID: <CA+55aFweMYR_8TFsfUNc0JxpNas06asUC-BvWi_T-XrhBtrtuw@mail.gmail.com>
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

On Tue, Jun 10, 2014 at 8:42 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ok, I'll take your patch-series rather than the recent pull from Andy,
> and pick up #2 that way too.

Hmm. In fact, #2 doesn't apply cleanly. It's trivial to fix up, but
rather than do that, the reject made me go "I'll just forward this to
Peter Anvin" instead, so that he's aware of the x32 issue.

            Linus
