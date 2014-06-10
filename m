Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbaFJEEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 00:04:38 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:54791 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaFJEEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 00:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140610025715.GA24314@kroah.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
 <20140609223057.GB18475@kroah.com> <CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
 <20140609224645.GA8113@kroah.com> <CA+5PVA6dHu-0qi1fx5Vq4QynJDJ=dG0feJjwoCHA3GaUSHp-FQ@mail.gmail.com>
 <20140610003142.GA20728@kroah.com> <CALCETrWYvQR5QRg7_tG3ZFk7dy0X7Ji50Lgxt81aqjjsxS7gCg@mail.gmail.com>
 <20140610025715.GA24314@kroah.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 9 Jun 2014 21:04:16 -0700
Message-ID: <CALCETrWzKCDezac4PHCXyZ8LJqitGiJJwNNL2tPNVLBCXOw9ZQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds checking
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 7:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 09, 2014 at 05:51:37PM -0700, Andy Lutomirski wrote:
>> [cc list trimmed, security@ added]
>>
>> On Mon, Jun 9, 2014 at 5:31 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Mon, Jun 09, 2014 at 07:35:57PM -0400, Josh Boyer wrote:
>> >> On Mon, Jun 9, 2014 at 6:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> >
>> >> > But yes, having something "real" might be good if the load gets higher,
>> >> > right now it's so low that my "sweep pending security patches" task
>> >> > usually catches anything pending, which is rare.
>> >>
>> >> How does one get added to the security@ alias?  We've been carrying
>> >> this patch in Fedora for a bit now.  I'd be happy to help track things
>> >> given we get distro security bug reports and such.
>> >
>> > Just ask on the security@ alias to be added and we can take it from
>> > there.
>> >
>>
>> Would it make sense for there to be someone on the security list who
>> can assign CVE numbers?
>
> I'm pretty sure we have that already.

Let me rephrase the question:

Would it make sense for someone on the security list to assign CVE numbers?

--Andy
