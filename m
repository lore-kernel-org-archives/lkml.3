Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbaDWRVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:21:55 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57166 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaDWRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:21:49 -0400
Date: Wed, 23 Apr 2014 18:25:23 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 0/3] of: dts: enable memory@0 quirk for PPC32 only
Message-ID: <20140423172523.GM5904@bivouac.eciton.net>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <CAL_JsqL8B2ZY7ACXKX3J8VN5ukjKWuycgfDZpp4kYzBxg6BLmQ@mail.gmail.com>
 <20140418124821.GE5904@bivouac.eciton.net>
 <CAL_JsqKdFyhHfkcC1E9QuKjQTrXwoELYG+CFTpgf2-jqDvxGmA@mail.gmail.com>
 <20140422130829.CA29DC4042C@trevor.secretlab.ca>
 <20140422140526.GK5904@bivouac.eciton.net>
 <20140423131508.6E53BC408D2@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423131508.6E53BC408D2@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 02:15:08PM +0100, Grant Likely wrote:
> > The reason for me doing that is because we (including you) agreed at
> > the discussion held during LCU13 that this was the safest way of
> > preventing "mischief" like userland trying to read information from
> > /proc/device-tree...
> 
> I'm not the most consistent of people. I often change my mind and then
> have no recollection of ever thinking differently.

And that is fine, but you were not the only person agreeing.

> Userland reading from /proc/device-tree isn't so much a problem, but
> kernel drivers doing it might be.
> 
> But, regardless of whether or not the stub clears out the memory
> nodes, it is still I think good practice for the kernel to make the
> decision to ignore memory nodes, and not rely on them being cleared
> correctly.

I also remember you saying that relaxing restrictions later on is a lot
easier than tightening them. On that basis, can we please get the UEFI
set merged before we start redefining the stub/kernel protocol which was
agreed at LCU (November last year) after spending a month or two trying
to get sufficient number of interested parties in the same room?

/
	Leif
