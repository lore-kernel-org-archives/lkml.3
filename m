Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3BYQUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:20:31 -0500
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:42800 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3BYQU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:20:29 -0500
Message-ID: <512B8F40.9090902@genband.com>
Date: Mon, 25 Feb 2013 10:20:16 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Florian Weimer <fw@deneb.enyo.de>, Peter Jones <pjones@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org> <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com> <20130221174955.GA20886@srcf.ucam.org> <CA+55aFxZ4f4KiHQBCAgTghm+deniS6rDz4wna9bce6vK8WppsA@mail.gmail.com> <20130222140539.GE20629@fenchurch.internal.datastacks.com> <877glw78p5.fsf@mid.deneb.enyo.de> <20130225154215.GB13605@srcf.ucam.org> <87obf85r51.fsf@mid.deneb.enyo.de> <20130225161435.GA18404@srcf.ucam.org>
In-Reply-To: <20130225161435.GA18404@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Feb 2013 16:20:18.0379 (UTC) FILETIME=[0060A1B0:01CE1374]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19664.004
X-TM-AS-Result: No--2.783500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 10:14 AM, Matthew Garrett wrote:
> On Mon, Feb 25, 2013 at 04:50:50PM +0100, Florian Weimer wrote:
>> * Matthew Garrett:
>>
>>> On Mon, Feb 25, 2013 at 03:46:14PM +0100, Florian Weimer wrote:
>>>
>>>> You could just drop the requirement that ring 0 code must be signed.
>>>> I don't think Windows 8 enforces this, but I'm not yet sure if there
>>>> is a physical presence check before you can enter a mode in which
>>>> Windows loads self-signed kernel modules.
>>>
>>> Windows 8 will not load unsigned drivers if Secure Boot is enabled.
>>
>> What about "bcdedit /set ... testsigning on"?
>
> Windows 8 will not load unsigned drivers if Secure Boot is enabled.

For reference:

http://msdn.microsoft.com/en-us/library/windows/desktop/hh848062%28v=vs.85%29.aspx

Chris
