Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3I1ATu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 20:19:50 -0400
Received: from wolff.to ([98.103.208.27]:43077 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753522Ab3I1ATr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 20:19:47 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Sep 2013 20:19:47 EDT
Date: Fri, 27 Sep 2013 19:09:51 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kernel: replace strict_strto*() with kstrto*()
Message-ID: <20130928000951.GA7019@wolff.to>
References: <000401ce86b7$0463f580$0d2be080$@samsung.com>
 <CAErSpo51GFB+yCuaHrwBqWjHxd0GboHgvWGov5pj4V6aGPfQHg@mail.gmail.com>
 <20130927195353.3643398a@endymion.delvare>
 <20130927131820.7fc04051.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20130927131820.7fc04051.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 13:18:20 -0700,
   Andrew Morton <akpm@linux-foundation.org> wrote:
>On Fri, 27 Sep 2013 19:53:53 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>
>> Andrew,
>>
>> On Fri, 27 Sep 2013 09:50:39 -0600, Bjorn Helgaas wrote:
>> > There's some indication that this change might have broken handling of
>> > signed types.  See
>> > https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-September/111758.html
>> > and https://bugzilla.kernel.org/show_bug.cgi?id=61811.
>>
>> It seems this is hurting more users than I would have expected, and
>> people are spending significant amounts of time to figure out what the
>> root cause to their problem is. May I suggest that my fix should find
>> its way to Linus' tree rather sooner than later?
>>
>
>Done.  I had to send that one by hand as I'm not at my desk...

I just did a successful test of the patch from the mailing list. So it at 
least solved the problem in my case.
