Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaHNFV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:21:58 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:61258 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaHNFV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:21:56 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <87wqac87dq.fsf@rustcorp.com.au>
References: <cover.1407764272.git.jani.nikula@intel.com>
	<87wqac87dq.fsf@rustcorp.com.au>
Date: Thu, 14 Aug 2014 07:21:55 +0200
Message-ID: <CAKMK7uGrT6jvsetM2av26CBEgQBv4b9asAP9kGN_-WdtT1bdkQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] module: add support for unsafe, tainting parameters
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:25 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Jani Nikula <jani.nikula@intel.com> writes:
>> This is a generic version of Daniel's patch [1] letting us have unsafe
>> module parameters (experimental, debugging, testing, etc.) that taint
>> the kernel when set. Quoting Daniel,
>
> OK, I think the idea is fine, but we'll probably only want this for
> a few types (eg. int and bool).  So for the moment I prefer a more
> naive approach.
>
> Does this work for you?

Can you please discuss this with yourself from a few months back?
We've done the general version since you suggested that just doing it
for int is a bit lame ;-) And I actually agreed so asked Jani to look
into that.

http://mid.mail-archive.com/87r46gywul.fsf@rustcorp.com.au

"If this is a good idea, you can write a macro module_param_unsafe_named
which is a general wrapper."

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
