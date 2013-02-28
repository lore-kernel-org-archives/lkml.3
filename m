Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3B1Pne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:43:34 -0500
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:35752 "EHLO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab3B1Pnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:43:33 -0500
Message-ID: <512F7B0E.1030404@genband.com>
Date: Thu, 28 Feb 2013 09:43:10 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Florian Weimer <fw@deneb.enyo.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <87ppzo79in.fsf@mid.deneb.enyo.de>	<30665.1361461678@warthog.procyon.org.uk>	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>	<20130221164244.GA19625@srcf.ucam.org>	<18738.1361836265@warthog.procyon.org.uk>	<20130226005955.GA19686@kroah.com>	<20130226023332.GA29282@srcf.ucam.org>	<20130226030249.GB23834@kroah.com>	<20130226031338.GA29784@srcf.ucam.org>	<20130226033156.GA24999@kroah.com> <8738wgsweq.fsf@mid.deneb.enyo.de>
In-Reply-To: <8738wgsweq.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Feb 2013 15:43:11.0436 (UTC) FILETIME=[504158C0:01CE15CA]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19678.000
X-TM-AS-Result: No--8.163100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 01:57 AM, Florian Weimer wrote:

> In any case, there's another reading of the UEFI Secure Boot
> requirements: you may run any code you wish after calling
> ExitBootServices().  That could be an unsigned, traditional GRUB.  But
> this will not generally address the issue of dual-booting Windows 8 in
> such a way that Windows sees that the device has enabled Microsoft
> Secure Boot.

Would it be possible to have a signed bootloader that allows booting 
Win8 from within the secure environment, or it could exit the secure 
environment and run unsigned grub?

Chris
