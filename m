Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab3BZWTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:19:50 -0500
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:42875 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3BZWTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:19:48 -0500
Message-ID: <512D34EC.6010204@genband.com>
Date: Tue, 26 Feb 2013 16:19:24 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Florian Weimer <fw@deneb.enyo.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Peter Jones <pjones@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <30665.1361461678@warthog.procyon.org.uk>	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>	<20130221164244.GA19625@srcf.ucam.org>	<CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>	<20130221174955.GA20886@srcf.ucam.org>	<CA+55aFxZ4f4KiHQBCAgTghm+deniS6rDz4wna9bce6vK8WppsA@mail.gmail.com>	<20130222140539.GE20629@fenchurch.internal.datastacks.com>	<877glw78p5.fsf@mid.deneb.enyo.de>	<20130225154215.GB13605@srcf.ucam.org>	<87obf85r51.fsf@mid.deneb.enyo.de>	<20130225161435.GA18404@srcf.ucam.org> <512B8F40.9090902@genband.com> <871uc2pxe5.fsf@mid.deneb.enyo.de>
In-Reply-To: <871uc2pxe5.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2013 22:19:25.0913 (UTC) FILETIME=[561F2490:01CE146F]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19670.002
X-TM-AS-Result: No--5.547200-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 03:40 PM, Florian Weimer wrote:
> * Chris Friesen:
>
>> On 02/25/2013 10:14 AM, Matthew Garrett wrote:
>>> Windows 8 will not load unsigned drivers if Secure Boot is enabled.
>>
>> For reference:
>>
>> http://msdn.microsoft.com/en-us/library/windows/desktop/hh848062%28v=vs.85%29.aspx
>
> Thanks.  Do you know perchance of any other Microsoft documentation in
> this area, that is, their PKI architecture, the signing and revocation
> policies, or even security objectives for the Secure Boot
> implementation?

Sorry, I got nothing. :)  I just happened to stumble over the above.

Chris
