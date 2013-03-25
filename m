Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab3CYNL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:11:58 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57136 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab3CYNL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <7566.1364216119@warthog.procyon.org.uk>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1362723313-839-5-git-send-email-lucas.demarchi@profusion.mobi>
 <20130309202537.GD16399@redhat.com> <7566.1364216119@warthog.procyon.org.uk>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Mon, 25 Mar 2013 10:11:34 -0300
Message-ID: <CAKi4VA+Fmk568gncTXxaHJArfi6b3RQUnycmZ6EgA-vC8XsOKQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KEYS: split call to call_usermodehelper_fns()
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 9:55 AM, David Howells <dhowells@redhat.com> wrote:
> Oleg Nesterov <oleg@redhat.com> wrote:
>
>> Looks correct, but can't we simpluify it a bit?
>>
>>       info = call_usermodehelper_setup(session_keyring);
>>       if (!info)
>>               return ENOMEM;
>
> -ENOMEM;-)

Yep, it's in -mm with -ENOMEM:
http://git.cmpxchg.org/?p=linux-mmotm.git;a=commitdiff;h=a8c67c6e380a8ff15997e8673e97d9fcdf7b8f9c

Lucas De Marchi
