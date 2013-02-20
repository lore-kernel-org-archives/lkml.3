Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935878Ab3BTUXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:23:50 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47541 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935790Ab3BTUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:23:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAKMK7uGDpSKga9=2SrGQDxBGzY5B1cGJAchZvfKfQy1ivRONMg@mail.gmail.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
	<20130219125217.6b6f55ff@jbarnes-desktop>
	<CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
	<CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com>
	<CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com>
	<CAKMK7uGDpSKga9=2SrGQDxBGzY5B1cGJAchZvfKfQy1ivRONMg@mail.gmail.com>
Date: Wed, 20 Feb 2013 12:23:41 -0800
X-Google-Sender-Auth: zD5WpxjsBh-qSku31pzMnBFMfPw
Message-ID: <CANeU7Qko6o9nJ-Rm3+hdQQC2iYDXKZq019H+B8ekxFULHwpB=Q@mail.gmail.com>
Subject: Re: i915 black screen introduced by ACPI changes
From: Chris Li <lkml@chrisli.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        robert.moore@intel.com, feng.tang@intel.com, len.brown@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 12:19 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> The debug option did not stick for some reason. Also you're hitting a
> bunch of WARNs in our driver self-checks. Iirc those should be fixed
> in the latest code. Can you please test with the latest
> drm-intel-nightly branch from
>
> http://cgit.freedesktop.org/~danvet/drm-intel

Sure, working on that.


>
> Also can you please attach a dmesg from a working kernel without the
> i915.modeset=0 option?

I did in one of my previous email, the attach file is "dmesg.3.6.10".
I just double check it without the "i915.modeset=0".

Chris
