Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3C1Isy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:48:54 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33836 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab3C1Isv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:48:51 -0400
Message-ID: <515403ED.6010008@gmail.com>
Date: Thu, 28 Mar 2013 10:48:45 +0200
From: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Dave Airlie <airlied@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "skeggsb@gmail.com" <skeggsb@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Murphy <bugzilla@colorremedies.com>
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM
 images
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com> <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com> <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com> <1364338554.2553.53.camel@x230.sbx07502.somerma.wayport.net> <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com>
In-Reply-To: <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-27 22:33, Bjorn Helgaas wrote:
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

Tested the three patches on top of v3.9-rc4-134-gb175293, works fine.


[the first patch refers to reverting commit f4eb5ff05, which doesn't
seem to exist; should probably have been 547b52463]

-- 
Mantas Mikulėnas <grawity@gmail.com>
