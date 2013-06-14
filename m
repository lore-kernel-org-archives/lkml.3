Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3FNUgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:36:36 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61519 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3FNUgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:36:35 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130614162319.GB14829@kroah.com>
References: <cover.1370525922.git.jani.nikula@intel.com>
	<87d2rzl4qp.fsf@intel.com>
	<20130613082205.GL22870@phenom.ffwll.local>
	<20130614162319.GB14829@kroah.com>
Date: Fri, 14 Jun 2013 22:36:35 +0200
X-Google-Sender-Auth: PoqZqbG1lTQJ_rQWIHcE1Yfxp08
Message-ID: <CAKMK7uE0sTCNMSVSsk_RBm99AUUg4Dxs2q0NOg96US96CwPOjA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 0/3]
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 6:23 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 13, 2013 at 10:22:05AM +0200, Daniel Vetter wrote:
>> On Thu, Jun 06, 2013 at 04:59:26PM +0300, Jani Nikula wrote:
>> >
>> > With Greg's address fixed. Please drop the old one from any
>> > replies. Sorry for the noise.
>>
>> Oops, replied with the old one still there.
>>
>> Greg, Andrew: Imo it's best to merge all three patches through the same
>> tree, so:
>>
>> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>
>> on the i915 parts of it. If you want I can also slurp them in through the
>> intel tree, including the new dmi match code.
>
> Please feel free to take them through your tree, I don't need to take
> them.

Andrew already merged them, so I think we're good.

Thanks, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
