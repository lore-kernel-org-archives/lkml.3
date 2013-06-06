Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3FFSnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:43:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3FFSnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:43:09 -0400
Message-ID: <51B0D835.3050808@suse.cz>
Date: Thu, 06 Jun 2013 20:43:01 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
Cc: Kyle McMartin <kyle@redhat.com>, linux-kbuild@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Kbuild: pass headers to headers_install.sh on stdin
References: <20130606170557.GQ14762@redacted.bos.redhat.com> <51B0C9E5.7030105@suse.cz> <20130606175529.GT14762@redacted.bos.redhat.com> <CA+5PVA4uNNSXcJHZfoyEmqMsCwK6hC7e2ziSdz5TNXwiiUQ7CQ@mail.gmail.com>
In-Reply-To: <CA+5PVA4uNNSXcJHZfoyEmqMsCwK6hC7e2ziSdz5TNXwiiUQ7CQ@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 6.6.2013 19:59, Josh Boyer napsal(a):
> On Thu, Jun 6, 2013 at 1:55 PM, Kyle McMartin <kyle@redhat.com> wrote:
>> On Thu, Jun 06, 2013 at 07:41:57PM +0200, Michal Marek wrote:
>>> Dne 6.6.2013 19:05, Kyle McMartin napsal(a):
>>>> While using make V=1 to test some things, I noticed on our builders that
>>>> headers_install was failing because the argument list to /bin/sh was too
>>>> long. Working around it is slightly kludgy...
>>>
>>> This is already fixed with
>>>
>>>
>>> commit c0ff68f1611d6855a06d672989ad5cfea160a4eb
>>> Author: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>> Date:   Mon Apr 29 14:15:51 2013 +0200
>>>
>>>     kbuild: fix make headers_install when path is too long
>>>
>>>
>>> in linux-next.
>>>
>>
>> OK, I guess.
> 
> Wait... not OK.  This is broken now.  People are clearly having to fix
> it again and wasting their time because a fix is already available.
> Why is a fix for it sitting in linux-next?  Please get that fix into
> Linus' tree.

This bug has been there for about five years (as far as I can tell, it
was introduced by 7712401). It is a coincidence that two people report
it now within a couple of weeks, but IMO this does not make the bug so
urgent that it can't wait for the next -rc1.

Michal
