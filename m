Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaJNLKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:10:53 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:56334 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaJNLKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <1413253178.3269.2.camel@joe-AO725>
References: <20141013023425.GA15452@devel>
	<20141013032544.GA26646@kroah.com>
	<CAHb8M2A5e2akETQoWS6WfNJjUqhyu4ptfTMs9HLYgbw8XRR-Ww@mail.gmail.com>
	<1413212198.1287.9.camel@joe-AO725>
	<20141014020433.GA25433@kroah.com>
	<1413253178.3269.2.camel@joe-AO725>
Date: Tue, 14 Oct 2014 20:10:51 +0900
Message-ID: <CAHb8M2CmtA8NGACCqNBeXWfVhLSBmu6sCoJ0tt_pcpHrvujS8Q@mail.gmail.com>
Subject: Re: [PATCH] staging: dgap: re-arrange functions for removing forward declarations.
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-10-14 11:19 GMT+09:00 Joe Perches <joe@perches.com>:
> On Tue, 2014-10-14 at 04:04 +0200, Greg KH wrote:
>> On Mon, Oct 13, 2014 at 07:56:38AM -0700, Joe Perches wrote:
>> > On Mon, 2014-10-13 at 17:01 +0900, DaeSeok Youn wrote:
>> > > 2014-10-13 12:25 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>> > > > On Mon, Oct 13, 2014 at 11:34:25AM +0900, Daeseok Youn wrote:
>> > > >> Re-arrange the functions for removing forward declarations.
> []
>> > > >> This patch has too many changes for re-arranging the functions.
>> > > >> So I wonder that I should break this up into smaller patches.
>> > > > Are the .o files identical before and after this patch?  If so, it's
>> > > > fine.
>> > > Ok. I will check for that.
>> > The .o files shouldn't be identical after function reordering.
>>
>> Hm, they might be the same size, but I can see how on some
>> architectures (like ppc) how that would not be the case, you are right.
>>
>> Isn't there an "objdiff" program or something like that which might help
>> in validating that nothing "changed" in the source for type of patch
>> that just moves functions around in a file.
>
> There is a scripts/objdiff, but that is basically for whitespace
> only changes.
>
> I don't know of a way to compare objects when functions are
> rearranged in the source file.
>
> Anyone else?
>
I was just trying to sort "objdump -d" output by function name with
someone's python script.
The script was on github. url : https://gist.github.com/fritschy/1183292

And I got two results, one is before applying this patch, another is
after doing that.
These are possible to compare but it has difference of base address...

I'm not sure what should I do for applying this patch. :-(
If anyone knows how to compare, let me know.

Thanks.

Regards,
Daeseok Youn.
