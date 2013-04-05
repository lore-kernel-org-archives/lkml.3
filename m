Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163065Ab3DEW2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:28:11 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:58585
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162901Ab3DEW2J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:28:09 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM images
From: Chris Murphy <bugzilla@colorremedies.com>
In-Reply-To: <CAErSpo7y4ROBVBaj==67oH8rNqV077frgFmfmk_PvODc94UwAQ@mail.gmail.com>
Date: Fri, 5 Apr 2013 16:28:06 -0600
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        =?utf-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Dave Airlie <airlied@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Ben Skeggs <skeggsb@gmail.com>, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <A1959DD9-E925-45D1-887B-74DA73B5FC59@colorremedies.com>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com> <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com> <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com> <1364338554.2553.53.camel@x230.sbx07502.somerma.wayport.net> <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com> <515403ED.6010008@gmail.com> <CAErSpo6T5KmTcm2fnoQZvSpJjzXozRd4AVL9REjn6gsL9Q1uPw@mail.gmail.com> <1364838466.19098.1.camel@x230> <CAErSpo4q3mU-0oi_xAUAjUpbDfFpU7Lb1rCnrd2WH67J2+U1hQ@mail.gmail.com> <E7324EBF-8BF5-450B-8CE4-9258B4806776@colorremedies.com> <CAErSpo7y4ROBVBaj==67oH8rNqV077frgFmfmk_PvODc94UwAQ@mail.gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 5, 2013, at 2:35 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Fri, Apr 5, 2013 at 2:31 PM, Chris Murphy <bugzilla@colorremedies.com> wrote:
>> 
>> 
>> Are they in 3.9.0-0.rc5.git2.1.f19? I'm seeing a regression from 3.8.5 with the radeon driver not finding BIOS ROM as well.
>> https://bugzilla.redhat.com/show_bug.cgi?id=949083
> 
> No.  I haven't asked Linus to pull my branch yet (was just thinking it
> was time to do that, coincidentally :))

The patch appears to fix Bug 949083 radeon issue as well. I've updated the bug report.