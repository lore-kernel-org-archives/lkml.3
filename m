Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab3DPQZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:25:49 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61739 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab3DPQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130416135137.GA31283@zurbaran>
References: <20130410134813.b1bff6027f64f14d75d43927@canb.auug.org.au>
	<20130410064253.GA4874@zurbaran>
	<20130410064828.6c946ad8@redhat.com>
	<20130416135137.GA31283@zurbaran>
Date: Tue, 16 Apr 2013 09:25:45 -0700
Message-ID: <CAHQ1cqEAQDRV4st4P+3NzVTiSDXW2+JwYE4DJOEHwyzyDGTwiw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mfd tree with the v4l-dvb tree
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 6:51 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Mauro,
>
> On Wed, Apr 10, 2013 at 06:48:28AM -0300, Mauro Carvalho Chehab wrote:
>> Em Wed, 10 Apr 2013 08:42:53 +0200
>> Samuel Ortiz <sameo@linux.intel.com> escreveu:
>>
>> > Hi Stephen,
>> >
>> > On Wed, Apr 10, 2013 at 01:48:13PM +1000, Stephen Rothwell wrote:
>> > > Hi Samuel,
>> > >
>> > > Today's linux-next merge of the mfd tree got a conflict in
>> > > drivers/mfd/Kconfig between commit 3f8ec5df11aa ("[media] mfd: Add header
>> > > files and Kbuild plumbing for SI476x MFD core") from the v4l-dvb tree and
>> > > commit ab85b120e692 ("mfd: Kconfig alphabetical re-ordering") from the
>> > > mfd tree.
>> > I'm surprised the v4l-dvb tree is carrying this patchset because I haven't
>> > ACKed it.
>>
>> Sorry. Not sure why I understood that you gave your ack. Perhaps I miss-read
>> one of the comments of that thread.
> I haven't heard back from Andrey yet. If I don't get anything from him on
> Wednesday, would you mind reverting this patchset ? I have not ACKed it
> because it breaks bisectability, and it conflicts with mfd-next.
>
> Andrey, any plans to adress my comments from last week ?

I have a new version of a patchset that addresses your comments and
incorporates a couple of other patches with bugfixes. Unfortunately I
haven't had a chance to run it on the test HW I have. I'll try to do
and post the patches this week, but I am not sure if I'll have time to
do it before Wednesday.

As far as I understand all the MFD patches will go through the "mfd"
tree which doesn't have any version of the SI476X related patches and
I don't have to worry about making incremental patches. This, however,
is not the case for "media_tree" this patch here
http://git.linuxtv.org/media_tree.git/commit/30bac9110455402fa8888740c6819dd3daa2666f
would be affected and I think that making the need changes
incrementally as a separate patch would break the bisectability also.
Right now what I have is a new version of said patch produced by
editing the history(rebase and squash). Would that work for you,
Mauro, or do you want an incremental patch on top of the original one?

>
> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
