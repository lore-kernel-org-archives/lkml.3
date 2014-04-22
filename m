Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaDVMOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:14:47 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56561 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaDVMOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:14:41 -0400
Message-ID: <53565D29.6010503@gmail.com>
Date: Tue, 22 Apr 2014 15:14:33 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Florian Weimer <fweimer@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Jim Lieb <jlieb@panasas.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Subject: Re: Thoughts on credential switching
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <53341D8E.80105@redhat.com> <20140327060225.4f4caa5a@ipyr.poochiereds.net> <53342258.8000304@redhat.com> <533428BF.8090007@gmail.com> <53565491.702@redhat.com>
In-Reply-To: <53565491.702@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 02:37 PM, Florian Weimer wrote:
> On 03/27/2014 02:33 PM, Boaz Harrosh wrote:
>> POSIX or not it just does not have any real programming mining
>> at all.
> 
> What do you mean with "mining" in this context?
> 

Sorry I saw this mistake after I posted. I meant "meaning".

What I'm saying is that the mess starts when you are trying
to keep patching a very wrong API. the POSIX politics aside,
in regard to user switching (and current directory and etc...)
this API is plain WRONG. I mean in the mathematical sense wrong.

All these application mess is not the application programmers
fault. He had to do what he had to do. The mess starts when you
are trying to keep a mathematical contradiction in your proof.

It is glibc mess for trying to maintain compatibility with
these "PROCESS WIDE OPERATIONS". And naming it holy names like
POSIX will not cover the mess that they are. As long as you try
to keep them there will be mess. If you want to honestly clean
things up is by throwing the true garbage out. Convert all legacy
code to new mathematically sound API's.

Peace
Boaz

