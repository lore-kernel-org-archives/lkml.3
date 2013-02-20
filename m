Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3BTXLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:11:37 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54072 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3BTXLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:11:36 -0500
MIME-Version: 1.0
In-Reply-To: <20130220223013.GA15760@redhat.com>
References: <20130216170605.GC4910@redhat.com>
	<1361325468-7998-1-git-send-email-msb@chromium.org>
	<20130220223013.GA15760@redhat.com>
Date: Wed, 20 Feb 2013 15:11:35 -0800
X-Google-Sender-Auth: n1ES86ZyMYvrnJmgEgyuAJXxbfw
Message-ID: <CACBanvrqe2jK1QBSUhbeX5qnz_Weg5iSCtG=B12ZoZNMtigWUw@mail.gmail.com>
Subject: Re: [PATCH v3] lockdep: check that no locks held at freeze time
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 2:30 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/19, Mandeep Singh Baines wrote:
>>
>> We shouldn't try_to_freeze if locks are held. Verified that
>> I get no lockdep warnings after applying this patch and
>> "vfork: don't freezer_count() for in-kernel users of CLONE_VFORK".
>
> I believe the patch is fine.
>
> But I don't understand the changelog, unless I am totally confused
> (and I have a lot of unread emails so perhaps I missed something),
> this version do not need the changes in CLONE_VFORK.
>

Thanks for catching that. The changelog is stale. I'll resend with a
new changelog that omits that sentence.

> And, Mandeep, I'll try to answer your emails asap...
>
> Oleg.
>
