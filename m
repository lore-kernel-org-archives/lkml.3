Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaHEXjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:39:20 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:61903 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaHEXjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:39:18 -0400
MIME-Version: 1.0
In-Reply-To: <1407279569.2170.18.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <20140725185048.GA27939@www.outflux.net>
	<CAGXu5jK--17NZvJK2BSWiANn4dkgLMUpGpoWrmy+jM=BfKkBxQ@mail.gmail.com>
	<1407279569.2170.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Tue, 5 Aug 2014 16:39:17 -0700
X-Google-Sender-Auth: QW1n3NXZGJM-nrk7va4R_-7jo9Y
Message-ID: <CAGXu5j+eQkSsqGPXp2uPRUn0Bvz0kdDBH=qnSiMy_cQBThdbyA@mail.gmail.com>
Subject: Re: [PULL] fw-restrict update (3.17)
From: Kees Cook <keescook@chromium.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 3:59 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2014-08-05 at 14:46 -0700, Kees Cook wrote:
>> On Fri, Jul 25, 2014 at 11:50 AM, Kees Cook <keescook@chromium.org> wrote:
>> > Hi James,
>> >
>> > Please pull these fw-restrict changes for 3.17. Thanks!
>>
>> James, did this ever get pulled? Does it need more review?
>>
>> Thanks!
>>
>
> They made it to the linux-security tree:
> 6593d92 firmware_class: perform new LSM checks
>
> $ git branch -r --contains 6593d92
>   dhowells-fs/keys-next
>   kees/for-security-next-fw-restrict
>   linux-next/akpm
>   linux-next/akpm-base
>   linux-next/master
>   origin/next          <=== linux-security

Ah! Fantastic. I missed that somehow. :)

-Kees


-- 
Kees Cook
Chrome OS Security
