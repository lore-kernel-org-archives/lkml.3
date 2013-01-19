Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3ASBNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:13:34 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60405 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3ASBNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:13:31 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <8514.1358557665@warthog.procyon.org.uk>
References: <1358556871-6651-1-git-send-email-sedat.dilek@gmail.com>
	<8514.1358557665@warthog.procyon.org.uk>
Date: Sat, 19 Jan 2013 02:13:30 +0100
Message-ID: <CA+icZUWhw5TZuXgqX5=8EviKMto2SKGqHzL2Ac1CG-v-p_2kDw@mail.gmail.com>
Subject: Re: [PATCH next-20130118 1/2] KEYS: Fix build-error when SYSTEM_TRUSTED_KEYRING=n
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 2:07 AM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> -     select KEYS
>> +     depends on KEYS
>
> This change was pushed upstream a few hours ago.  It may not have made it into
> linux-next yet.
>

I know, but this patch is 1/2.
OK, I could have done one single patch, but anyway :-).
The series is for people testing Linux-Next (see my label in the
subject-line) and trapping into the pitfall.
Patches are cheap...

- Sedat -


> David
