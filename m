Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab3DBULU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:11:20 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53484 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab3DBULS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:11:18 -0400
MIME-Version: 1.0
In-Reply-To: <1364838466.19098.1.camel@x230>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
 <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com>
 <1364338554.2553.53.camel@x230.sbx07502.somerma.wayport.net>
 <CAErSpo7ZYMsRAp=EKMS0YPmiw6YytN4pZVzoWPd-PL5EzT8+SQ@mail.gmail.com>
 <515403ED.6010008@gmail.com> <CAErSpo6T5KmTcm2fnoQZvSpJjzXozRd4AVL9REjn6gsL9Q1uPw@mail.gmail.com>
 <1364838466.19098.1.camel@x230>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 2 Apr 2013 14:10:58 -0600
Message-ID: <CAErSpo4q3mU-0oi_xAUAjUpbDfFpU7Lb1rCnrd2WH67J2+U1hQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM images
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Dave Airlie <airlied@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "skeggsb@gmail.com" <skeggsb@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Murphy <bugzilla@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 11:47 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Mon, 2013-04-01 at 11:39 -0600, Bjorn Helgaas wrote:
>
>> Chris still has problems (see
>> https://bugzilla.redhat.com/show_bug.cgi?id=927451), but I don't know
>> whether they are related to these patches or something else.
>
> I think they're unrelated. The log he posts using this patch gives the
> correct output - the ROM image comes from the platform method rather
> than from PCI. I think Ben probably needs to look at that.

OK, I added these three patches to my for-linus branch, headed for v3.9.
