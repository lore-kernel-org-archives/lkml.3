Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbaGCVYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:24:15 -0400
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:33768
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbaGCVYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:24:14 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=KpbD2AmN c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=JT5DoUvwEhkA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=NwNaNvtAQ0FkTAP6Vs4A:9
 a=QEXdDO2ut3YA:10
Date: Thu, 3 Jul 2014 22:24:11 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <greg@kroah.com>, Michael Marineau <mike@marineau.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_UEVENT_HELPER default
Message-ID: <20140703212411.GB23074@milliways>
References: <Pine.LNX.4.44L0.1406241421050.888-100000@iolanthe.rowland.org>
 <CAHW-aUfJedVUkYxxD-GSNaQg+FvXDXGW9Q9HaTknBeGZMF9REA@mail.gmail.com>
 <20140624183310.GA4955@kroah.com>
 <53A9D7AE.8000305@mit.edu>
 <20140624223509.GA21551@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140624223509.GA21551@milliways>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:35:09PM +0100, Ken Moffat wrote:
> On Tue, Jun 24, 2014 at 12:55:26PM -0700, Andy Lutomirski wrote:
> > On 06/24/2014 11:33 AM, Greg KH wrote:
> > > On Tue, Jun 24, 2014 at 11:30:05AM -0700, Michael Marineau wrote:
> > >> On Jun 24, 2014 11:23 AM, "Alan Stern" <stern@rowland.harvard.edu> wrote:
> > >>>
[ snipping most of this ]
> (i.) I got the option with 'make oldconfig' and, after reading the
> help, made a decision.  But, in the absence of other problems, and
> if the help text is correct, it looks as if a kernel built after
> accepting the default 'Y' here with recent userspace might grind to
> a halt after "successfully" booting?  That sounds slightly better
> than "fails to boot", but only slightly.  Maybe the problem needs
> a lot of modules, or is it something like "it will hang for a minute,
> then boot" ?
> 
> (ii.) I understand that people continue to use ancient userspace,
> and for that the 'Y' option is needed.  Using ancient userspace is
> a worthwhile thing for _somebody_ to try.  But where is the line
> between "you need to enable this" and "enabling this might be a
> really bad idea" ?  Maybe a specific version of udev ?
> 
 Now that I have managed to boot -rc3, with the default 'Y' on a
recent system (linuxfromscratch from May), it appears to work fine.

 So, the text implies that bad things might happen, but so far I have
not seen them.  I'll stop caring.

ĸen
-- 
Nanny Ogg usually went to bed early. After all, she was an old lady.
Sometimes she went to bed as early as 6 a.m.
