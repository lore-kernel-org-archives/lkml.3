Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaAFHYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:24:04 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:34294 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaAFHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:24:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140105212951.4e13b083@alan.etchedpixels.co.uk>
References: <CAPNrq4yXdbdfq4hrtZdZn_5UDPduGoTCNJb1-9u-Qf1nf2RgXQ@mail.gmail.com>
 <20140105212951.4e13b083@alan.etchedpixels.co.uk>
From: "Gideon D'souza" <gidisrael@gmail.com>
Date: Mon, 6 Jan 2014 12:53:41 +0530
Message-ID: <CAPNrq4yJBEJo3yadttN2G_+-nmUPihvDCR8M6R7KGO3LO_kDMA@mail.gmail.com>
Subject: Re: How does a newbie find work?
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I was thinking of this hideous project (don't laugh!) at tearing
out the CFS scheduler and then rewriting a very dumb scheduler in it's
place. What do you guys think?  This is of course just to understand
the scheduler better.

I just don't know how large or ridiculous this is though :)



On Mon, Jan 6, 2014 at 2:59 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> I've made small contributions to other OSS projects before but now I'm
>> at a loss for how to study the kernel code base, what to try to
>> break/change to study how the kernel works.
>
> LXR is useful for finding code and where it goes, but the kernel is a big
> project. Don't assume anyone knows how of all it works.
>
>> Is there some simple work a newbie like me can take up? Any maintainer
>> need some grunt work done? Or perhaps someone could suggest a pet
>> project I could try to understand things better? (Should I be learning
>> how to write device drivers?)
>>
>> Things that are very interesting to me so far are the KVM and the Scheduler.
>
> Then I would fiddle with KVM and the scheduler !
>
> Alan
