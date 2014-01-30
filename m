Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaA3U5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 15:57:11 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42696 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3U5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 15:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6jobif4fNJdFKtWvSdPbnhioKPOj4kD=V8-_m0C4AFmw@mail.gmail.com>
References: <CA+5PVA4Oj7XOZSEYqXGE7ZPVVK1oEHEc-w_DniCediWGVhrmhQ@mail.gmail.com>
	<20140130190513.GB16260@htj.dyndns.org>
	<CA+5PVA6jobif4fNJdFKtWvSdPbnhioKPOj4kD=V8-_m0C4AFmw@mail.gmail.com>
Date: Thu, 30 Jan 2014 15:57:09 -0500
X-Google-Sender-Auth: 7gedCVSjamx7Wf21J3mOVGKh8nM
Message-ID: <CA+5PVA6RXSwaSYnc7fdL84DbzXyXqwt=fgD6SMMec0X20n-Atw@mail.gmail.com>
Subject: Re: kernfs oops with i915+i2c_core in 3.14 merge window
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, Wolfram Sang <wsa@the-dreams.de>,
        intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 2:20 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Thu, Jan 30, 2014 at 2:05 PM, Tejun Heo <tj@kernel.org> wrote:
>> On Thu, Jan 30, 2014 at 02:03:18PM -0500, Josh Boyer wrote:
>>> Hi All,
>>>
>>> I'm seeing the oops below on my MacBookPro 10,2 machine using i915
>>> graphics.  It's after the DRM merge for 3.14 ( v3.13-10094-g9b0cd30) ,
>>> but we seem to have one report[1] of this happening well before that,
>>> in v3.13-3260-g03d11a0 as well.  Does anyone have a clue what is going
>>> on here?
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=1055105
>>
>> Should be fixed by the following patch which is already queued.
>>
>>  http://lkml.kernel.org/g/20140129170403.GJ30842@htj.dyndns.org
>
> Oh, excellent!  I'll throw that into a build and test it here.  Thanks
> for the quick reply, Tejun.

FWIW, my test build with that patch does seem to solve the problem.
Thanks again.

josh
