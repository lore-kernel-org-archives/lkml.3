Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3EVUKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:10:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46431 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3EVUKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:10:24 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130522200012.GA15456@redhat.com>
References: <20130521230332.GC12713@redhat.com> <519D1668.6000601@zytor.com> <20130522200012.GA15456@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: microcode loading got really slow.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 22 May 2013 13:09:52 -0700
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com
Message-ID: <ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bisect would be appreciated.  Cc Fenghua.

Dave Jones <davej@redhat.com> wrote:

>On Wed, May 22, 2013 at 12:03:04PM -0700, H. Peter Anvin wrote:
> > On 05/21/2013 04:03 PM, Dave Jones wrote:
> > > In 3.10-rc2 I see this happening..
> > > 
> > > [   72.318133] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x6
> > > [  132.446449] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x6
> > > [  192.573101] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x6
>> > [  252.702055] microcode: Microcode Update Driver: v2.00
><tigran@aivazian.fsnet.co.uk>, Peter Oruba
> > > 
>> > For some reason the events for udev seem to be getting delayed 60s
>for each core.
> > > 
> > > 	Dave
> > > 
> > 
> > Is this a regression from -rc1?
>
>No. Looks like it was introduced between 3.9 and 3.10-rc1
>
>I see bisecting in my future.
>
>	Dave

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
