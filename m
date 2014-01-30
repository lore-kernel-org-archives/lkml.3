Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaA3SGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:06:25 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38769 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaA3SGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:06:21 -0500
MIME-Version: 1.0
In-Reply-To: <201401301521.11665.arnd@arndb.de>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com>
 <CAErSpo7Dfd4NJBEDuVe1VCvZObFq1YvV2x77S60Z4-CZq89QJw@mail.gmail.com>
 <CACoXjc=LSrLK=kd9GJoHWJovVDC+TfH2bZO-2Ht9jMoBrL9eag@mail.gmail.com> <201401301521.11665.arnd@arndb.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 30 Jan 2014 11:06:00 -0700
Message-ID: <CAErSpo79zaf_92KCVkUSCrZLHML0B365K6Q6-0p1LEVVQJ=cVA@mail.gmail.com>
Subject: Re: [RFC PATCH V3 0/4] APM X-Gene PCIe controller
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 7:21 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 30 January 2014, Tanmay Inamdar wrote:
>> >
>> > When you repost, please make sure you fix whatever problem is
>> > preventing your email from appearing on the vger mailing lists.  I
>> > won't apply things that haven't appeared on the linux-pci list,
>> > because that list is the opportunity for other people to review them.
>> >
>> You are absolutely right. If the patches are not reaching mailing
>> list, they should not appear on archive list as well. However I am
>> seeing my patches recorded on archives. So I am not sure if they are
>> actually getting dropped on linux-pci or any other mailing list.
>>
>> http://www.spinics.net/lists/linux-pci/msg28198.html
>> http://article.gmane.org/gmane.linux.kernel.pci/28442/match=tanmay+inamdar
>
> Very strange. I can also confirm that I received the patches through
> the linux-arm-kernel and devicetree mailing lists without problems.

Sorry, the problem was on my end.  I must have mistakenly marked one
of those messages as spam, and gmail thought all the rest were spam,
too.  Sorry about that.

Bjorn
