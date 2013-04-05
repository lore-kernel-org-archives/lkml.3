Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162263Ab3DEUf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:35:28 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48052 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162070Ab3DEUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <E7324EBF-8BF5-450B-8CE4-9258B4806776@colorremedies.com>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
 <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com>
 <1364338554.2553.53.camel@x230.sbx07502.somerma.wayport.net>
 <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com>
 <515403ED.6010008@gmail.com> <CAErSpo6T5KmTcm2fnoQZvSpJjzXozRd4AVL9REjn6gsL9Q1uPw@mail.gmail.com>
 <1364838466.19098.1.camel@x230> <CAErSpo4q3mU-0oi_xAUAjUpbDfFpU7Lb1rCnrd2WH67J2+U1hQ@mail.gmail.com>
 <E7324EBF-8BF5-450B-8CE4-9258B4806776@colorremedies.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 5 Apr 2013 14:35:05 -0600
Message-ID: <CAErSpo7y4ROBVBaj==67oH8rNqV077frgFmfmk_PvODc94UwAQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM images
To: Chris Murphy <bugzilla@colorremedies.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Dave Airlie <airlied@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Ben Skeggs <skeggsb@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 2:31 PM, Chris Murphy <bugzilla@colorremedies.com> wrote:
>
> On Apr 2, 2013, at 2:10 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>> On Mon, Apr 1, 2013 at 11:47 AM, Matthew Garrett
>> <matthew.garrett@nebula.com> wrote:
>>> On Mon, 2013-04-01 at 11:39 -0600, Bjorn Helgaas wrote:
>>>
>>>> Chris still has problems (see
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=927451), but I don't know
>>>> whether they are related to these patches or something else.
>>>
>>> I think they're unrelated. The log he posts using this patch gives the
>>> correct output - the ROM image comes from the platform method rather
>>> than from PCI. I think Ben probably needs to look at that.
>>
>> OK, I added these three patches to my for-linus branch, headed for v3.9.
>
> Are they in 3.9.0-0.rc5.git2.1.f19? I'm seeing a regression from 3.8.5 with the radeon driver not finding BIOS ROM as well.
> https://bugzilla.redhat.com/show_bug.cgi?id=949083

No.  I haven't asked Linus to pull my branch yet (was just thinking it
was time to do that, coincidentally :))

Bjorn
