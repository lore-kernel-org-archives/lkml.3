Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161903Ab3DEITZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:19:25 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:64473 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161150Ab3DEITW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 5 Apr 2013 01:19:00 -0700
X-Google-Sender-Auth: joSlU6MWEzEilIleUogE-d0pa2g
Message-ID: <CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
Subject: Re: Version number policy!
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 11:27 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> Here's my first take on the version number policy:
>
> https://github.com/qca/open-ath9k-htc-firmware/wiki/VersionPolicy
>
> The summary:
>
> * major version number changes are for firmware API / behaviour
> changes that aren't backwards compatible;
> * minor version number changes are for firmware API / behaviour
> changes that are incremental and default to the old behaviour (eg, new
> optional commands);
> * the driver should check the minor version number before using any
> optional features with that version.
>
> What's TODO:
>
> * Add a new WMI command to get the build number, git string, etc.
> * add it as our first optional minor version command :-)

This is better than anything we had drafted before for 802.11 open
firmware design rules. Cc'ing a few lists for wider review given that
what we had written before for rules was for 802.11 and Bluetooth [0]
and it was very Linux specific. We are striving for open firmware here
for the community, for BSD / Linux. Christian would have dealt with
more of the support on open firmware design so far due to carl9170.fw
[1] so curious if he has any input.

As for 802.11 the rules we defined were pretty silly about firmware
file names but should be considered. Here's the key thing I think we
should keep from those old guidelines:

"In general if you are just providing bug fixes you do not need to
provide a new firmware filename for the module, using the old filename
is fine so long as the same API was kept."

The rest I think your specification details better what we should do
in terms of API changes for versioning.

[0] http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
[1] http://wireless.kernel.org/en/users/Drivers/carl9170.fw

  Luis
