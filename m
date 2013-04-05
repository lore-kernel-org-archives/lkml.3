Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161922Ab3DEIVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:21:17 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34300 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3DEIVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
Date: Fri, 5 Apr 2013 01:21:06 -0700
X-Google-Sender-Auth: df88rk8HX5ym0EnnJDISkHSnO8c
Message-ID: <CAJ-Vmom7gNBhyuBgg9YkCLRohR6eE-JfBYYtxfFeTkSiGhgHyw@mail.gmail.com>
Subject: Re: Version number policy!
From: Adrian Chadd <adrian@freebsd.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2013 01:19, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> This is better than anything we had drafted before for 802.11 open
> firmware design rules. Cc'ing a few lists for wider review given that
> what we had written before for rules was for 802.11 and Bluetooth [0]
> and it was very Linux specific. We are striving for open firmware here
> for the community, for BSD / Linux. Christian would have dealt with
> more of the support on open firmware design so far due to carl9170.fw
> [1] so curious if he has any input.
>

I'm treating it like shared libraries should be treated - minor
versions shouldn't break existing stuff, just add new calls. Major
versions are incompatible.

We'll see how well this scales after people hack at it for a while.



Adrian
