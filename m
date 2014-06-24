Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaFXTzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:55:32 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37654 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFXTza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:55:30 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <53A9D7AE.8000305@mit.edu>
Date: Tue, 24 Jun 2014 12:55:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Michael Marineau <mike@marineau.org>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_UEVENT_HELPER default
References: <Pine.LNX.4.44L0.1406241421050.888-100000@iolanthe.rowland.org> <CAHW-aUfJedVUkYxxD-GSNaQg+FvXDXGW9Q9HaTknBeGZMF9REA@mail.gmail.com> <20140624183310.GA4955@kroah.com>
In-Reply-To: <20140624183310.GA4955@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 11:33 AM, Greg KH wrote:
> On Tue, Jun 24, 2014 at 11:30:05AM -0700, Michael Marineau wrote:
>> On Jun 24, 2014 11:23 AM, "Alan Stern" <stern@rowland.harvard.edu> wrote:
>>>
>>> Michael and Greg:
>>>
>>> The help text for CONFIG_UEVENT_HELPER says (among other things):
>>>
>>>           This should not be used today, because usual systems create
>>>           many events at bootup or device discovery in a very short time
>>>           frame.
>>>
>>> If it shouldn't be used, why does it default to 'y'?
>>>
>>> Alan Stern
>>>
>>
>> To introduce the option but not change the default behavior. (yet?) I don't
>> really have an opinion one way or the other, I just defaulted to being
>> conservative.
> 
> Yes, being conservative is good as turning this off with older systems
> (like the pathological Fedora 3 system that some kernel developers still
> use for testing), would result in a non-booting box.  So if you know
> that your system is "new enough", it's safe to turn off, but if you have
> a doubt, leave it on to be safe.

As far as I know, there's no real requirement that a defconfig kernel be
able to boot old userspace.  We want an oldconfig kernel to be able to
boot old userspace, but changing the default won't affect that.

For example, a defconfig kernel won't boot opensuse 9.

--Andy
