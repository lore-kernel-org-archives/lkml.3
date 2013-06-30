Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3F3JFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 05:05:36 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:40757 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3F3JFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 05:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130630003348.GA23378@kroah.com>
References: <20130627175936.GA8732@kroah.com> <CA+QCeVTdiGNz05_L0MWVnY6W88tgt_gy4Duk5MoUR7Xi6KpRsg@mail.gmail.com>
 <20130630003348.GA23378@kroah.com>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Sun, 30 Jun 2013 12:05:11 +0300
Message-ID: <CA+QCeVTkpr2XxzyqswJcTpWiOWRR5QyMjbeDubih7CqZotmGXw@mail.gmail.com>
Subject: Re: Linux 3.9.8
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        lwn <lwn@lwn.net>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2013 03:33, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Jun 29, 2013 at 11:58:04PM +0300, Sergey Meirovich wrote:
>> Hi,
>>
>> On 27 June 2013 20:59, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > I'm announcing the release of the 3.9.8 kernel.
>> >
>> > All users of the 3.9 kernel series must upgrade.
>>
>> I've got issues with my radeon ("01:00.0 VGA compatible controller:
>> Advanced Micro Devices, Inc. [AMD/ATI] Thames [Radeon HD 7500M/7600M
>> Series]") APU on 3.9.8
>
> But 3.9.7 worked?  Can you run 'git bisect' to track down the offending
> commit?

The last previous  3.9.X kernel I checked was 3.9.5 will try 3.9.7 a
bit later as well as git bisect stuff


> Does 3.10-rc7 also have this problem?

3.10-rc7 doesn't have this problem


>
> thanks,
>
> greg k-h
