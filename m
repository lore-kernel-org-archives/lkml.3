Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3H3Iqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:46:47 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:41349 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3H3Iqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:46:45 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
CC: linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        "Manfred Spraul" <manfred@colorfullife.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>
Subject: Re: ipc-msg broken again on 3.11-rc7?
Thread-Topic: ipc-msg broken again on 3.11-rc7?
Thread-Index: AQHOpV1ua2zPW4yZMkWQwZduFtEUDA==
Date: Fri, 30 Aug 2013 08:46:39 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751411CB@IN01WEMBXA.internal.synopsys.com>
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com>
 <CA+icZUVbUD1tUa_ORtn_ZZebpp3gXXHGAcNe0NdYPXPMPoABuA@mail.gmail.com>
 <1372192414.1888.8.camel@buesod1.americas.hpqcorp.net>
 <CA+icZUXgOd=URJBH5MGAZKdvdkMpFt+5mRxtzuDzq_vFHpoc2A@mail.gmail.com>
 <1372202983.1888.22.camel@buesod1.americas.hpqcorp.net>
 <521DE5D7.4040305@synopsys.com>
 <CA+icZUUrZG8pYqKcHY3DcYAuuw=vbdUvs6ZXDq5meBMjj6suFg@mail.gmail.com>
 <C2D7FE5348E1B147BCA15975FBA23075140FA3@IN01WEMBXA.internal.synopsys.com>
 <CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com>
 <52205597.3090609@synopsys.com>
 <CA+icZUW=YXMC_2Qt=cYYz6w_fVW8TS4=Pvbx7BGtzjGt+31rLQ@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 01:57 PM, Sedat Dilek wrote:
> On Fri, Aug 30, 2013 at 10:19 AM, Vineet Gupta <vineetg76@gmail.com> wrote:
>> Ping ?
>>
>> It seems 3.11 is pretty close to releasing but we stil have LTP msgctl08 causing a
>> hang (atleast on ARC) for both linux-next 20130829 as well as Linus tree.
>>
>> So far, I haven't seemed to have drawn attention of people involved.
>>
> 
> Hi Vineet,
> 
> I remember fakeroot was an another good test-case for me to test this
> IPC breakage.
> Attached is my build-script for Linux-next (tested with Debian/Ubuntu).
> ( Cannot say if you can play with it in your environment. )

Hi Sedat,

I have a simpler buildroot based rootfs (initramfs based) and LTP is run off of
NFS, although running of a local storage doesn't make a difference.

For me msgctl08 standalone (w/o hassle of running full LTP) is enough to trigger
it consistently.

P.S. sorry my sender address kept flipping - mailer was broken !

-Vineet

