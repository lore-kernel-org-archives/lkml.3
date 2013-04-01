Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab3DARjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:39:49 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49557 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab3DARjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:39:48 -0400
MIME-Version: 1.0
In-Reply-To: <515403ED.6010008@gmail.com>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
 <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com>
 <1364338554.2553.53.camel@x230.sbx07502.somerma.wayport.net>
 <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com> <515403ED.6010008@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Apr 2013 11:39:26 -0600
Message-ID: <CAErSpo6T5KmTcm2fnoQZvSpJjzXozRd4AVL9REjn6gsL9Q1uPw@mail.gmail.com>
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM images
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Dave Airlie <airlied@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "skeggsb@gmail.com" <skeggsb@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Murphy <bugzilla@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 2:48 AM, Mantas Mikulėnas <grawity@gmail.com> wrote:
> On 2013-03-27 22:33, Bjorn Helgaas wrote:
>> On Tue, Mar 26, 2013 at 4:55 PM, Matthew Garrett
>> <matthew.garrett@nebula.com> wrote:
>>> On Tue, 2013-03-26 at 16:53 -0600, Bjorn Helgaas wrote:
>>>
>>>> I've been on vacation and didn't follow this closely, but it seems
>>>> like this fixes a regression and should be merged before v3.9, right?
>>>> Can you include a reference to a bugzilla or the mailing list
>>>> discussion in the changelog?  I can just fold it in if you want.
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=927451
>>
>> Thanks, I added that URL and queued up these patches.  I'll wait to
>> push them until we have confirmation from Mantas [1] and Chris [2]
>> that this fixes it for both.
>
> Tested the three patches on top of v3.9-rc4-134-gb175293, works fine.
>
>
> [the first patch refers to reverting commit f4eb5ff05, which doesn't
> seem to exist; should probably have been 547b52463]

Both Chris and Mantas have tested these patches.  Mantas reports success.

Chris still has problems (see
https://bugzilla.redhat.com/show_bug.cgi?id=927451), but I don't know
whether they are related to these patches or something else.

Matthew or Dave, can you take a look at the bugzilla so we can make
some progress with these?

Bjorn
