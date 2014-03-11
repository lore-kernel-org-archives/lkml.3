Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaCKFUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:20:48 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:63053 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaCKFUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140309070642.GA2525@needle>
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
	<20140305053617.GE26240@dhcp-17-89.nay.redhat.com>
	<20140306064756.GB16859@needle.mulix.org>
	<53181AC1.2020807@zytor.com>
	<20140306070047.GF16859@needle.mulix.org>
	<CAPoiz9yhAeoWDANus6=O_5AomKFEAzzR1pR4F0rN2HnDWwYAMg@mail.gmail.com>
	<20140309070642.GA2525@needle>
Date: Mon, 10 Mar 2014 22:20:45 -0700
Message-ID: <CAPoiz9xDUb1aoYMfj8jnQRTKo8GCH5PyfNjDd-04=AQXrQjBCA@mail.gmail.com>
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
From: Jon Mason <jdmason@kudzu.us>
To: Muli Ben-Yehuda <muli@cs.technion.ac.il>
Cc: "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>,
        kexec@lists.infradead.org, discuss@x86-64.org, x86@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 12:06 AM, Muli Ben-Yehuda <muli@cs.technion.ac.il> wrote:
> On Thu, Mar 06, 2014 at 07:46:44AM -0700, Jon Mason wrote:
>
>> > I don't know of anyone still using it, but it's not
>> > impossible. Calgary and CalIOC2 machines would now be ~5-8 years
>> > old.
>>
>> It is getting a bit crufty in arch/x86.  Would it be better to move
>> it to drivers/iommu?
>
> Not sure I see the potential benefit... I think for Calgary it's
> either leave it in arch/x86 or rip it out.

The intent is for it go where the other IOMMU drivers are, and gain
changes to the overall infrastructure as it evolves.  There has been a
decent amount of work going on in there  :)

Of course, someone would have to put the effort in and test it.

>
> Cheers,
> Muli
