Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab3AOX0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:26:07 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60614 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab3AOX0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130115231530.GB18802@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	<CAFLxGvxWs79ZCigDtBfkdu0mMk8Cfm6xNzzPZkoPKT9pTc9zrA@mail.gmail.com>
	<20130115231530.GB18802@redhat.com>
Date: Wed, 16 Jan 2013 00:17:45 +0100
Message-ID: <CAFLxGvxdJdnJHWzf5-zpyMRYiCiK27AUsz7iBe=3gqA__0R06Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] ELF executable signing and verification
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        zohar@linux.vnet.ibm.com, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 12:15 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Jan 15, 2013 at 11:27:12PM +0100, richard -rw- weinberger wrote:
>> On Tue, Jan 15, 2013 at 10:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Upon exec(), we determine if executable is signed. If it is, then locks
>> > down the pages in memory (using MAP_LOCKED) and verfies the signature.
>> > If signature does not match, process is killed. Unsigned processes
>> > don't get affected at all.
>>
>> Also ptrace() should be disallowed on such a process created from a signed ELF.
>
> Yes, that I have listed in TODO. We need to disable ptrace for signed
> processes or make sure only signed process can trace it.

Memo to myself: Reading long mails on my Android sucks. ;)
I totally missed the TODO section. Sorry for the noise.

-- 
Thanks,
//richard
