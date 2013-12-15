Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3LOX4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:56:55 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64271 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3LOX4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:56:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131215231413.GA6853@kroah.com>
References: <20131215063123.GB26396@localhost> <20131215170417.GB28799@kroah.com>
 <CAErSpo4Usujp5zJT83-88T71J8tObJgZ03i-wORqLputxQbdXg@mail.gmail.com> <20131215231413.GA6853@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sun, 15 Dec 2013 16:56:31 -0700
Message-ID: <CAErSpo5R5fTLj0X+qc2Rkmvvjzdrbx0s-rW8iXMuSsqJmGjVmw@mail.gmail.com>
Subject: Re: BUG: key ffff8800192a6ad0 not in .data!
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 4:14 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Dec 15, 2013 at 03:12:03PM -0700, Bjorn Helgaas wrote:
>> On Sun, Dec 15, 2013 at 10:04 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Sun, Dec 15, 2013 at 02:31:23PM +0800, Fengguang Wu wrote:
>> >> Greetings,
>> >>
>> >> I got the below dmesg and the first bad commit is
>> >
>> > I thought this was already fixed in Bjorn's tree, but perhaps he hasn't
>> > merged in the one-liner for it...
>>
>> Yes, this is fixed.  I actually dropped that MSI change temporarily
>> until we can fold in the memory leak fixes, so it is not currently in
>> linux-next.
>
> Do you want me to just resend a fixed patch up with the one-line fix,
> and the memory-leak-on-error-path fix all as just one patch to make it
> easier for you?

It's fine either way.  I'm happy to incorporate an incremental patch
if that's easier for you.

Bjorn
