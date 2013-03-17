Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3CQOcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:32:16 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47849 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3CQOcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130317140528.GA2494@kroah.com>
References: <20130314184702.GA17860@kroah.com> <CAE8XmWoYXyNFQ14e6X+2rkWQyRA=kSdc4J+DNu2Sv+6e9rvZRg@mail.gmail.com>
 <20130317140528.GA2494@kroah.com>
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Sun, 17 Mar 2013 22:31:52 +0800
Message-ID: <CAE8XmWpP=PB_Dx5xM7Oa3UxziA0bMSxCxcJ9a5tS7XmZ-3zDTA@mail.gmail.com>
Subject: Re: Linux 3.8.3
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 10:05 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, Mar 17, 2013 at 10:00:08PM +0800, Dongsheng Song wrote:
>> On Fri, Mar 15, 2013 at 2:47 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >
>> > I'm announcing the release of the 3.8.3 kernel.
>> >
>> > All users of the 3.8 kernel series must upgrade.
>> >
>> > The updated 3.8.y git tree can be found at:
>> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.8.y
>> > and can be browsed at the normal kernel.org git web browser:
>> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>> >
>> > thanks,
>> >
>> > greg k-h
>>
>> Hi,
>>
>> “make ARCH=arm menuconfig”  no complains,  but "make ARCH=arm
>> CROSS_COMPILE=arm-linux-gnueabihf-" failed:
>
> Is this new (i.e. does 3.8.2 work?)
>
> If so, what commit caused it?
>
> thanks,
>
> greg k-h

Sorry, I do not know, I'm newbie to arm, this is my first DIY.
