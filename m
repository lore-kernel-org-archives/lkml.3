Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3AYKKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:10:50 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:49617 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3AYKKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:10:46 -0500
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <CAAG0J9-JQswfnEaqrKPor71DO8dn=qW4Ba6tni0sdwn9OYWL9w@mail.gmail.com>
References: <20130119003923.GH24579@htj.dyndns.org>
	<20130119004100.GL24579@htj.dyndns.org>
	<20130125001345.GA1960@balrog>
	<20130125010112.GF2373@mtj.dyndns.org>
	<CAAG0J9-JQswfnEaqrKPor71DO8dn=qW4Ba6tni0sdwn9OYWL9w@mail.gmail.com>
Date: Fri, 25 Jan 2013 10:10:44 +0000
Message-ID: <CAAG0J9_rUq1c-UFy1mVssqpognLUuCGsq1sDOLK+z8ue6A-ZqQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] async: replace list of active domains with global
 list of pending items
From: James Hogan <james@albanarts.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 January 2013 10:08, James Hogan <james@albanarts.com> wrote:
> On 25 January 2013 01:01, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> On Fri, Jan 25, 2013 at 12:13:45AM +0000, James Hogan wrote:
>>> Should it have this?
>>> +     else
>>> +             INIT_LIST_HEAD(&entry->global_list)
>>
>> I think it would be better to have INIT_LIST_HEAD() during @entry
>> initialization.  Heh, I forgot that.  I wonder why it didn't crash on
>> my machine.  Can you please cook up a patch to init both list fields
>> right after kzalloc()?
>
> How does the following patch look? Feel free to squash it into the
> original to avoid breaking bisection :).

Sorry, gmail has screwed with the patch. I'll send separately.

Cheers
James
