Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaCFXp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:45:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52738 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaCFXp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:45:26 -0500
Message-ID: <5319087A.8000109@zytor.com>
Date: Thu, 06 Mar 2014 15:44:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        libseccomp-discuss@lists.sourceforge.net
Subject: Re: Making a universal list of syscalls?
References: <CALCETrWbjazg_kAY1uAB+cMTdaJqtyGrTwQWNFCSzZ56B0KEkw@mail.gmail.com> <15044.1394017702@warthog.procyon.org.uk> <531906C7.5030409@zytor.com> <CALCETrXt7bqQxymOC0ke+4Uaqv7nGOHqw3YhVHf4YKvJ4b8WpQ@mail.gmail.com>
In-Reply-To: <CALCETrXt7bqQxymOC0ke+4Uaqv7nGOHqw3YhVHf4YKvJ4b8WpQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 03:40 PM, Andy Lutomirski wrote:
> On Thu, Mar 6, 2014 at 3:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 03/05/2014 03:08 AM, David Howells wrote:
>>> It would be really nice if we could do this in such a manner that we could
>>> build strace from it.
>>
>> strace, seccomp, klibc, ... we all need more or less the same stuff.
> 
> strace also needs to know what the pointed-to type is for pointer
> arguments, whether pointers are input, output, or both, and what kind
> of flags / constants fit in which integer slot.
> 

Yes.  That kind of information also needs to be annotated.

It might take a while to get there, but it should be part of the design.

	-hpa


