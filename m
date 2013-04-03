Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220Ab3DCOCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:02:18 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:41831 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab3DCOCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130312221030.GB27330@kroah.com>
References: <20130301194355.578429064@linuxfoundation.org> <1362172344.20156.15.camel@x61.thuisdomein>
 <1362253682.3768.136.camel@deadeye.wl.decadent.org.uk> <1362263724.1334.18.camel@x61.thuisdomein>
 <1362265843.3768.162.camel@deadeye.wl.decadent.org.uk> <1362306002.1334.29.camel@x61.thuisdomein>
 <5134617F02000078000C2AD8@nat28.tlf.novell.com> <1362388302.16460.5.camel@x61.thuisdomein>
 <5134741702000078000C2B3E@nat28.tlf.novell.com> <20130304150246.GA15794@phenom.dumpdata.com>
 <20130312221030.GB27330@kroah.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 3 Apr 2013 16:01:54 +0200
Message-ID: <CAJ75kXZDTpJUnKp+UJ+3kib9Wog0yRgXn1m+DDgHaMwr=1=4UA@mail.gmail.com>
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>, Paul Bolle <pebolle@tiscali.nl>,
        Ian Campbell <ian.campbell@citrix.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:10 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>> > >> IOW I don't see why this got proposed for stable at all.
>> > >
>> > > So, you suggest to just drop this patch for v3.8.3, don't you?
>> >
>> > I do, yes. But I'd suggest to get Konrad to agree.
>>
>> Yes. Lets drop it.
>
> Now reverted, thanks.

Seems like still present in 3.4.x branch. Is that a mistake?

Regards,
--
William
