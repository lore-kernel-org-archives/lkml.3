Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3C0UfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:35:14 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38960 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3C0UfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
 <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com>
 <1364338554.2553.53.camel@x230.sbx07502.somerma.wayport.net> <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 27 Mar 2013 14:34:48 -0600
Message-ID: <CAErSpo7rKr8Hi9nvenDbzhJCR5GFFn12dRYuEPY76YBOJEgoLg@mail.gmail.com>
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM images
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Dave Airlie <airlied@gmail.com>, Alex Deucher <alexander.deucher@amd.com>,
        "skeggsb@gmail.com" <skeggsb@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "grawity@gmail.com" <grawity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Murphy <bugzilla@colorremedies.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Wed, Mar 27, 2013 at 2:33 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Mantas, Chris]
>
> On Tue, Mar 26, 2013 at 4:55 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
>> On Tue, 2013-03-26 at 16:53 -0600, Bjorn Helgaas wrote:
>>
>>> I've been on vacation and didn't follow this closely, but it seems
>>> like this fixes a regression and should be merged before v3.9, right?
>>> Can you include a reference to a bugzilla or the mailing list
>>> discussion in the changelog?  I can just fold it in if you want.
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=927451
>
> Thanks, I added that URL and queued up these patches.  I'll wait to
> push them until we have confirmation from Mantas [1] and Chris [2]
> that this fixes it for both.
>
> [1] http://marc.info/?l=linux-kernel&m=136148818405871
> [2] https://bugzilla.redhat.com/show_bug.cgi?id=927451
