Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3DXQPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:15:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36246 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3DXQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:15:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1304241637530.29143@pobox.suse.cz>
References: <1366626999-6270-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<alpine.LNX.2.00.1304241637530.29143@pobox.suse.cz>
Date: Wed, 24 Apr 2013 19:15:47 +0300
Message-ID: <CAHp75Veyy=YUvLbzNGKskbcPMf-USf9hrYA7W0ihOEK2jk3Gbw@mail.gmail.com>
Subject: Re: [PATCH] lib: fix trivial typo in the comment
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 5:38 PM, Jiri Kosina <jkosina@suse.cz> wrote:

>> - * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
>> + * This routine returns 0 if the first character is one of 'Yy1Nn0'.
>>   * Otherwise it will return -EINVAL.  Value pointed to by res is
>>   * updated upon finding a match.
>>   */
>
> And this is correct because ... ?

So, in this case it means "if and only if", true?

--
With Best Regards,
Andy Shevchenko
