Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3IYDR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:17:56 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58581 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3IYDRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130922141410.GA1974@redhat.com>
References: <CA+icZUXyizuCR3YDfFXD5hCkgycFYGzMHaJxg=m9UackT7uzGQ@mail.gmail.com>
	<CAKMK7uFzwiztE8H1rvSDWQmw08JGoKdnTs5BYqxdrHwb=pK50A@mail.gmail.com>
	<CA+icZUXnHaT75NhhSx+AhcMEKybHugH9+hV_mS5h5-cimFdz6A@mail.gmail.com>
	<CA+icZUVQ_UO_VnN9+Q7B3hhuFmw4XPEw19rhO+T4jU5hLGWaTQ@mail.gmail.com>
	<CA+icZUW3K7RyUcfdos7aOkrEOd3To0kSns+G3GSfkPqqwo7z=w@mail.gmail.com>
	<20130826130511.GA21082@redhat.com>
	<20130922141410.GA1974@redhat.com>
Date: Wed, 25 Sep 2013 13:17:52 +1000
Message-ID: <CAPM=9ty_o7VZx+sfDRSwh7U9BC+gOLd7P-cc856+PDBXR-UMEA@mail.gmail.com>
Subject: Re: Fwd: linux-next: Tree for Jul 1 [ drm-intel-next: Several
 call-traces ]
From: Dave Airlie <airlied@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:14 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Mon, Aug 26, 2013 at 04:05:11PM +0300, Michael S. Tsirkin wrote:
>> On Wed, Aug 21, 2013 at 11:22:58AM +0200, Sedat Dilek wrote:
>> > [ Re: [Intel-gfx] i915 producing warnings with kernel 3.11-rc5 ]
>> >
>> > Hi,
>> >
>> > saw your posting in [1]... can you try the patches below?
>> > Not sure if they apply.
>> > Did you try v3.11-rc6(+)... or drm-intel-nightly?
>> >
>> > Regards,
>> > - Sedat -
>> >
>> > [1] http://lists.freedesktop.org/archives/intel-gfx/2013-August/032154.html
>>
>> Same thing observed with v3.11-rc7.
>
> I still see this with 3.11.
> Following this message, my VGA monitor goes blank and
> shows an error suggesting a wrong resolution or frequency are set.
> Anyone?

Daniel, Jesse?

still ongoing I think.

Dave.
