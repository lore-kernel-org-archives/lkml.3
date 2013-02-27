Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317Ab3B0TV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:21:59 -0500
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:36101 "EHLO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3B0TV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:21:58 -0500
Message-ID: <512E5C9F.2050800@genband.com>
Date: Wed, 27 Feb 2013 13:21:03 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Peter Jones <pjones@redhat.com>,
        Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <20130226033156.GA24999@kroah.com> <20130226033803.GA30285@srcf.ucam.org> <20130226035416.GA1128@kroah.com> <20130226040456.GA30717@srcf.ucam.org> <20130226041324.GA7241@kroah.com> <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com> <20130226044521.GC12906@thunk.org> <20130226165451.GE32160@fenchurch.internal.datastacks.com> <20130227152429.GA5609@thunk.org> <512E4409.2040907@genband.com> <20130227175947.GA16966@thunk.org>
In-Reply-To: <20130227175947.GA16966@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2013 19:21:04.0811 (UTC) FILETIME=[962E4FB0:01CE151F]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19674.001
X-TM-AS-Result: No--8.351000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 11:59 AM, Theodore Ts'o wrote:
> On Wed, Feb 27, 2013 at 11:36:09AM -0600, Chris Friesen wrote:
>> ...
>> At this point you've got a running infected Win8 install that is
>> running on Secure Boot hardware but is actually running malware.
>>
>> Admittedly this would be tricky to do reliably in a way that the
>> user doesn't notice, so it may not actually be a real-world threat.
>
> That's another thing which is extraordinarily vague.  What counts as
> "user doesn't notice"?  If a whole bunch of kernel messages scroll by,
> is that enough?  What if a Penguin jpg shows up for a minimum 5
> seconds?  15 seconds?  30 seconds?

I think it'd need to be "doesn't notice operationally when running the 
virtualized Windows install".

Anyone going through all the trouble to virtualize an existing install 
could probably arrange to have the target computer do the conversion at 
a time when nobody is likely to be around.

Chris
