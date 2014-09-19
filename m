Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaISCEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:04:35 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:57516 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaISCEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:04:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140918181926.GA19520@thunk.org>
References: <CAJhHMCBhN7iVOBVJmoFBiLVurs2uncnJ57p5RBeC5z=_kSgUfg@mail.gmail.com>
 <20140918181926.GA19520@thunk.org>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 18 Sep 2014 22:04:02 -0400
Message-ID: <CAJhHMCB_i1PAFwhzFaoURLzPSrhAu+Y8wExBbSsd8_0JSPaz+Q@mail.gmail.com>
Subject: Re: BUG in ext4_setattr
To: "Theodore Ts'o" <tytso@mit.edu>, Pranith Kumar <bobby.prani@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 2:19 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 18, 2014 at 12:01:00PM -0400, Pranith Kumar wrote:
>>
>> The following splat occurs in the latest rc5+ kernel. I am not sure
>> this is enough information. Please let me know what options to enable
>> to get more meaningful info.
>
> This is a PowerMac, apparently.  I don't know why we can get symbol
> information for at least part of the stack, but not for the fault
> location.
>
> Is this repeatable?  If so, the best way to go forward is a bisection
> search.
>

I got this twice today, but sadly it is not repeating afterwards. I am
getting errors elsewhere though. So may be it is an issue with the
hardware.


-- 
Pranith
