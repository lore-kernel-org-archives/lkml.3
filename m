Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab3CDRLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:11:35 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62033 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab3CDRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:11:32 -0500
MIME-Version: 1.0
In-Reply-To: <CANeU7Q=hbU89zfcrP15ZAqMYaZPhQzM4f7i71txQDmESt0J36w@mail.gmail.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
	<20130219125217.6b6f55ff@jbarnes-desktop>
	<CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
	<CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com>
	<CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com>
	<CAKMK7uGDpSKga9=2SrGQDxBGzY5B1cGJAchZvfKfQy1ivRONMg@mail.gmail.com>
	<CANeU7Q=K4Adu3yokT182ZaG3hW04bhDiXhyZgjngd7Nn+JD3aQ@mail.gmail.com>
	<CANeU7QmMYERbg9fCnyGuDcEdzwfErNT4B_7YbAD7w243hWdaQQ@mail.gmail.com>
	<CANeU7Q=hbU89zfcrP15ZAqMYaZPhQzM4f7i71txQDmESt0J36w@mail.gmail.com>
Date: Mon, 4 Mar 2013 09:11:31 -0800
X-Google-Sender-Auth: H2a43bVCpSsF5RM2G9Pyqj37poY
Message-ID: <CANeU7Q=ge+z=uzpWdvXbfpZ0vaA0C0bnZcPBad5zKGyj1DmLAA@mail.gmail.com>
Subject: Re: i915 black screen introduced by ACPI changes
From: Chris Li <lkml@chrisli.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        robert.moore@intel.com, feng.tang@intel.com, len.brown@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping,

To recap, the black screen first show up after the ACPI change to use widows 8
string. The i915_setmode function did not crash. The printk output
from that function seems the same as the one that is in 3.6 kernel.
I also include the 3.6 and 3.7 kernel dmesg. The black screen is 100%
reproducible.

Any suggestion how to further debug this i9515 black screen problem?
I really want to get it fixed.

Thanks

Chris

On Fri, Feb 22, 2013 at 2:42 PM, Chris Li <lkml@chrisli.org> wrote:
> Ping. Any update for this black screen problem?
>
> Chris
>
> On Wed, Feb 20, 2013 at 1:04 PM, Chris Li <lkml@chrisli.org> wrote:
>> Here is the dmesg with "drm.debug=0xe" at
>> 80187431762989ebade986468d3c548287a12689
>>
>> That is the 3.6 kernel, exactly one commit before the ACPI commit
>> which  triggering the black screen.
>>
>> Thanks
>>
>> Chris
