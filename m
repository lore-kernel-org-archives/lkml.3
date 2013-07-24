Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab3GXGGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:06:48 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51924 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3GXGGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:06:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130723205229.GA11261@kroah.com>
References: <20130723193712.GA9385@kroah.com> <CE1443D8.57081%andreas.dilger@intel.com>
 <20130723205229.GA11261@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 24 Jul 2013 14:06:25 +0800
Message-ID: <CA+a=Yy5ZUk81n4wXtcrHFeSandzQuUXTwr6fzTwxLgZPw5vXQA@mail.gmail.com>
Subject: Re: [PATCH 02/48] staging/lustre/obdclass: restore lu_ref
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 4:52 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 23, 2013 at 08:31:15PM +0000, Dilger, Andreas wrote:
>> On 2013/07/23 1:37 PM, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
>> wrote:
>>
>> >On Tue, Jul 23, 2013 at 12:06:23AM +0800, Peng Tao wrote:
>> >> lu_ref.[ch] were mistakenly removed by coan2. Add them back and guard
>> >> with CONFIG_LUSTRE_DEBUG_LU_REF_CHECK.
>> >
>> >Ick, why?  Why not use the in-kernel infrastructure for this type of
>> >thig, _iff_ you really need it.
>> >
>> >Why do you need this at all, isn't the reference code fully debugged by
>> >now, given that this has been running for years?  I would only expect to
>> >see something like this in new code that is still being developed.
>>
>> Lustre is still being developed, so it is useful to be able to enable this
>> debugging to catch any new problems that are introduced.
>
> Ok, then use the in-kernel infrastructure for this type of thing, don't
> roll your own and add custom stuff that will later just have to be
> ripped out and converted to use the in-kernel stuff.
>
OK. Will drop this one.

Thanks,
Tao
