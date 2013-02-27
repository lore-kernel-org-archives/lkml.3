Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345Ab3B0Rg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:36:26 -0500
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:54576 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3B0RgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:36:23 -0500
Message-ID: <512E4409.2040907@genband.com>
Date: Wed, 27 Feb 2013 11:36:09 -0600
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
References: <20130226030249.GB23834@kroah.com> <20130226031338.GA29784@srcf.ucam.org> <20130226033156.GA24999@kroah.com> <20130226033803.GA30285@srcf.ucam.org> <20130226035416.GA1128@kroah.com> <20130226040456.GA30717@srcf.ucam.org> <20130226041324.GA7241@kroah.com> <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com> <20130226044521.GC12906@thunk.org> <20130226165451.GE32160@fenchurch.internal.datastacks.com> <20130227152429.GA5609@thunk.org>
In-Reply-To: <20130227152429.GA5609@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2013 17:36:11.0104 (UTC) FILETIME=[EED6D600:01CE1510]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19674.000
X-TM-AS-Result: No--3.740200-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 09:24 AM, Theodore Ts'o wrote:
> On Tue, Feb 26, 2013 at 11:54:51AM -0500, Peter Jones wrote:
>> No, no, no.  Quit saying nobody knows.  We've got a pretty good idea -
>> we've got a contract with them, and it says they provide the signing
>> service, and under circumstances where the thing being signed is found
>> to enable malware that circumvents Secure Boot
>
> The question is what does "malware that circuments Secure Boot" mean?
> Does starting up a hacked KVM and running Windows 8 under KVM so that
> malare can be injected count as circumenting Secure Boot?  If so, will
> you have to disable KVM, too?

I could see an argument for KVM to require either a signed binary or 
else someone at the keyboard to explicitly okay loading the image. 
Anything else breaks the chain of trust.

It may be somewhat far-fetched, but I think it would be possible to take 
an existing secure-boot Win 8 install, turn it into a VM but with an 
infected kernel. Then install a signed Linux distro that runs the Win8 
VM as a guest.

At this point you've got a running infected Win8 install that is running 
on Secure Boot hardware but is actually running malware.

Admittedly this would be tricky to do reliably in a way that the user 
doesn't notice, so it may not actually be a real-world threat.

Chris
