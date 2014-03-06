Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaCFXlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:41:04 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:46465 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaCFXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:41:00 -0500
MIME-Version: 1.0
In-Reply-To: <531906C7.5030409@zytor.com>
References: <CALCETrWbjazg_kAY1uAB+cMTdaJqtyGrTwQWNFCSzZ56B0KEkw@mail.gmail.com>
 <15044.1394017702@warthog.procyon.org.uk> <531906C7.5030409@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 6 Mar 2014 15:40:40 -0800
Message-ID: <CALCETrXt7bqQxymOC0ke+4Uaqv7nGOHqw3YhVHf4YKvJ4b8WpQ@mail.gmail.com>
Subject: Re: Making a universal list of syscalls?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        libseccomp-discuss@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 3:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/05/2014 03:08 AM, David Howells wrote:
>> It would be really nice if we could do this in such a manner that we could
>> build strace from it.
>
> strace, seccomp, klibc, ... we all need more or less the same stuff.

strace also needs to know what the pointed-to type is for pointer
arguments, whether pointers are input, output, or both, and what kind
of flags / constants fit in which integer slot.

--Andy

>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
