Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab3JRPmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:42:04 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58103 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3JRPmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:42:01 -0400
MIME-Version: 1.0
In-Reply-To: <1382059831.2794.18.camel@deadeye.wl.decadent.org.uk>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
 <CAErSpo5+xbgTfBrQdP36PRfOFpQcdeSgOEBFFDCfZoqoAsch5g@mail.gmail.com> <1382059831.2794.18.camel@deadeye.wl.decadent.org.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 18 Oct 2013 09:41:40 -0600
Message-ID: <CAErSpo5MPkySEb+tURxjh+f8p8xTi=Mnuj1W5g2=TAoXFDZ2Qg@mail.gmail.com>
Subject: Re: [ 3.8.y.z extended stable ] Linux 3.8.13.11 stable review
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kernel-team@lists.ubuntu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 7:30 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Thu, 2013-10-10 at 11:37 -0600, Bjorn Helgaas wrote:
>> On Thu, Oct 10, 2013 at 9:40 AM, Kamal Mostafa <kamal@canonical.com> wrote:
>> > This is the start of the review cycle for the Linux 3.8.13.11 stable kernel.
>>
>> Would anybody be interested in adding some sort of "stable" tag to the
>> subject lines of stable backport patches, e.g.,  instead of:
>>
>>   [PATCH 001/104] htb: fix sign extension bug
>>
>> something like:
>>
>>   [STABLE 3.8.13.11 001/104] htb: fix sign extension bug
>>
>> I don't mind having the stable patches on LKML, but it would be nice
>> if it were easier to distinguish stable backports from new patches.  I
>> know the patches are nicely threaded behind this message, but some
>> readers don't really pay attention to that.
>
> I agree that some distinction is needed, but I'm not convinced about
> that precise format.  I don't think it's worth including version
> components after the stable base version e.g. 3.2.  And I think that
> including the version is a big enough clue that this is for a stable
> branch and not mainline.
>
> So I've changed my review script to put a subject prefix of 'PATCH 3.2'
> before the patch number (and similarly in the cover letter).  But if
> there's consensus that a more explicit tag is wanted then I'll follow
> that.

Selfishly, I would just like something gmail can filter on.  I've seen
an "X-Extended-Stable: 3.8" header, which would be perfect, except
that I can't figure out how to create a gmail filter for random
headers.  So I was hoping for something stable-specific in the subject
line, but that's just to compensate for gmail's limitations.

Bjorn
