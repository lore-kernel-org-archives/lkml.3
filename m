Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbaGSDfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 23:35:48 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:62562 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaGSDfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 23:35:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140719013138.GA21252@home.goodmis.org>
References: <CANZNk81LiTM9vY0dRV=T0BCT9k-BxU45Ojw_PyOcpdmtXHKM2Q@mail.gmail.com>
	<20140718222215.GF18775@thunk.org>
	<20140719013138.GA21252@home.goodmis.org>
Date: Sat, 19 Jul 2014 11:35:45 +0800
Message-ID: <CAJd=RBBqW-Nk62DnNW3XDERbmzwqROhw9dAu9avSXn2891m3dg@mail.gmail.com>
Subject: Re: How to automate checkpatch && get_maintainers && git send-email
 of commits range?
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        kernelnewbies@kernelnewbies.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 9:31 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, Jul 18, 2014 at 06:22:15PM -0400, Theodore Ts'o wrote:
>>
>> And then think very hard about which patches people need to see in
>> order to be able to evaluate a patch.  For example, if you have patch
>> 1 out of a series which adds a new function, and then patches 2
>> through 1000 modify a thousand different drivers to use that new
>> function, if you use an automated get_maintainers.pl script to send
>> each patch to just the maintainer, then the device driver maintainer
>> might not see patch #1 which is critical context to understanding the
>> patch that you want to make to his driver.  And then you will have
>> several hundred very angry and annoyed developers wondering why you
>> sent them patch 345/1000, with no other context, and wondering what
>> the heck they are supposed to do with the email that you have just
>> launched into their inbox.
>
> I'm still stuck in the old stone/quilt age, where I use quilt mail to
> send my patch bombs. Although, I have scripts that pulls my patches out
> from git with format-patch, and then creates a quilt queue from them.
> I do this for that very reason that I want to review all patches before
> I hit send, and quilt mail is very basic and sends what I tell it.
> I still a bit gun shy from using git sendmail as I never got that to
> work (note, the last time I tried, it was still doing the staircase
> threads with patches by default).
>
> I'm still content with quilt, but the one thing I don't care about it
> is that all Cc'd on the 0/1000 patch gets Cc'd on all patches. I wish
> there was a way to tell quilt that they should only get Cc'd on the
> cover patch and no more, unless the patch has them Cc'd. The reason this
> bothers me is that I tend to do exactly what you stated above. I will
> just Cc patch 345/1000 to someone with no context of what that patch
> is.
>
> I figured people would do the same thing that I do when I get that 345th
> patch. As I'm subscribed to LKML, I will just go into my lkml folder and
> search for that patch and see how that thread applies to me with full
> context. I'm assuming that's what others may do too.
>
Hi Steve

Why not share your quilt skills, say by adding a file in the Document directory?

Hillf
