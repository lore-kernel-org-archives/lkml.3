Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3JRP4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:56:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3JRP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:56:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Kamal Mostafa <kamal@canonical.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        kernel-team@lists.ubuntu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 3.8.y.z extended stable ] Linux 3.8.13.11 stable review
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
	<CAErSpo5+xbgTfBrQdP36PRfOFpQcdeSgOEBFFDCfZoqoAsch5g@mail.gmail.com>
	<1382059831.2794.18.camel@deadeye.wl.decadent.org.uk>
	<CAErSpo5MPkySEb+tURxjh+f8p8xTi=Mnuj1W5g2=TAoXFDZ2Qg@mail.gmail.com>
Date: Fri, 18 Oct 2013 16:56:19 +0100
In-Reply-To: <CAErSpo5MPkySEb+tURxjh+f8p8xTi=Mnuj1W5g2=TAoXFDZ2Qg@mail.gmail.com>
	(Bjorn Helgaas's message of "Fri, 18 Oct 2013 09:41:40 -0600")
Message-ID: <87ob6mwp24.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> On Thu, Oct 17, 2013 at 7:30 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> On Thu, 2013-10-10 at 11:37 -0600, Bjorn Helgaas wrote:
>>> On Thu, Oct 10, 2013 at 9:40 AM, Kamal Mostafa <kamal@canonical.com> wrote:
>>> > This is the start of the review cycle for the Linux 3.8.13.11 stable kernel.
>>>
>>> Would anybody be interested in adding some sort of "stable" tag to the
>>> subject lines of stable backport patches, e.g.,  instead of:
>>>
>>>   [PATCH 001/104] htb: fix sign extension bug
>>>
>>> something like:
>>>
>>>   [STABLE 3.8.13.11 001/104] htb: fix sign extension bug
>>>
>>> I don't mind having the stable patches on LKML, but it would be nice
>>> if it were easier to distinguish stable backports from new patches.  I
>>> know the patches are nicely threaded behind this message, but some
>>> readers don't really pay attention to that.
>>
>> I agree that some distinction is needed, but I'm not convinced about
>> that precise format.  I don't think it's worth including version
>> components after the stable base version e.g. 3.2.  And I think that
>> including the version is a big enough clue that this is for a stable
>> branch and not mainline.
>>
>> So I've changed my review script to put a subject prefix of 'PATCH 3.2'
>> before the patch number (and similarly in the cover letter).  But if
>> there's consensus that a more explicit tag is wanted then I'll follow
>> that.
>
> Selfishly, I would just like something gmail can filter on.  I've seen
> an "X-Extended-Stable: 3.8" header, which would be perfect, except
> that I can't figure out how to create a gmail filter for random
> headers.  So I was hoping for something stable-specific in the subject
> line, but that's just to compensate for gmail's limitations.
>
> Bjorn

I don't really mind changing the scripts we're currently using to make
life easier for filtering, although I would expect that the extra
'X-Extended-Stable' header would do the job (this was the reason we
added it in the first place).

Since the only header that can be parsed is the 'Subject:', it's just
a matter of agreeing on the format (personally, I don't have any
strong opinion on this).

Cheers,
-- 
Luis
