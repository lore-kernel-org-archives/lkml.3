Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaKYTHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:07:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:7366 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbaKYTHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:07:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,457,1413270000"; 
   d="scan'208";a="613918192"
Message-ID: <5474D35A.3000601@linux.intel.com>
Date: Tue, 25 Nov 2014 11:07:06 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <CACxGe6stjCvaQZkh=hFcF-56v5qJVar11jRZz0PRSd2wz6EUyA@mail.gmail.com> <5474A78C.7030805@linux.intel.com> <20141125172120.GI7712@sirena.org.uk> <5474CB5D.9050807@linux.intel.com> <20141125184304.GK7712@sirena.org.uk>
In-Reply-To: <20141125184304.GK7712@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/25/14 10:43, Mark Brown wrote:
> On Tue, Nov 25, 2014 at 10:33:01AM -0800, Darren Hart wrote:
>> On 11/25/14 09:21, Mark Brown wrote:
> 
>>> Given the design of _DSD is to share with DT and we already 
>>> have device tree bindings for the device we should be using, 
>>> it's not clear to me if we want to grind them all through UEFI 
>>> and I suspect they'd be unhappy if we tried but pretty much
>>> all audio CODECs are good candidates for use with ACPI given
>>> the new hardware designs Intel have so if we are doing it I
>>> ought to be bouncing everyone to UEFI forum.
> 
>> Right, I realized between sending and driving into the office 
>> that my statement might be construed this way. I meant *new*
>> _DSD bindings should go through the ACPI/UEFI forum. Where we
>> can reuse DT bindings, we should absolutely do that, agreed. We 
>> should still document this and link to the DT binding so it can 
>> be referenced and used even when Linux is not the target OS.
> 
> Link from where - do we want to talk to the ACPI/UEFI forum and 
> figure out some kind of fast track process for them to add an
> "it's already covered by DT, see here" entry to their database for 
> example?  We also ought to work out how to make sure ACPI IDs are 
> registered there as well, should be possible to have something 
> simple as part of that.
> 

This is a current topic with the ACPI working group. We have the
following document:

http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf

I don't know if we want to have a list of them here, or if a separate
document is needed. The important point is that it is independent from
the ACPI specification itself so that it can be updated out of band
with the specification, and not be subject to rather plodding pace
that would imply.

Rafael, I've missed several of these meetings unfortunately, and I'm
not sure if we've closed on this point. Do you know?

-- 
Darren Hart
Intel Open Source Technology Center
