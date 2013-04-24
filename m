Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3DXQ0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:26:04 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:34921 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3DXQ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:26:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1304241823310.29143@pobox.suse.cz>
References: <1366626999-6270-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<alpine.LNX.2.00.1304241637530.29143@pobox.suse.cz>
	<CAHp75Veyy=YUvLbzNGKskbcPMf-USf9hrYA7W0ihOEK2jk3Gbw@mail.gmail.com>
	<alpine.LNX.2.00.1304241823310.29143@pobox.suse.cz>
Date: Wed, 24 Apr 2013 19:26:00 +0300
Message-ID: <CAHp75VeSS78u_w9K8GnZx3_LzUy+Nbm+V6EcOmOqqCa6CPPVFw@mail.gmail.com>
Subject: Re: [PATCH] lib: fix trivial typo in the comment
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 7:24 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 24 Apr 2013, Andy Shevchenko wrote:
>
>> >> - * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
>> >> + * This routine returns 0 if the first character is one of 'Yy1Nn0'.
>> >>   * Otherwise it will return -EINVAL.  Value pointed to by res is
>> >>   * updated upon finding a match.
>> >>   */
>> >
>> > And this is correct because ... ?
>>
>> So, in this case it means "if and only if", true?
>
> Yes, and that's in accordance with what the function does, isn't it?

Apparently, yes.
Please, discard the patch. It's quite good to learn something new,
though the term is confusing for me as ESL speaker.


--
With Best Regards,
Andy Shevchenko
