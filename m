Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3IXRxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:53:39 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55583 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3IXRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6m+gR6Ycumfy4CwQzWwd-wHiWjeVH9259oH6X+yyF6AQ@mail.gmail.com>
References: <bug-61811-41252@https.bugzilla.kernel.org/> <CAErSpo6m+gR6Ycumfy4CwQzWwd-wHiWjeVH9259oH6X+yyF6AQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 24 Sep 2013 11:53:17 -0600
Message-ID: <CAErSpo5R_CZtRx6bFQbiAam_rPBSGm5vSDSabDsLETvgP9TaOw@mail.gmail.com>
Subject: Re: [Bug 61811] New: kms mode breaks and using radeon.agpmode=-1
To: bruno@wolff.to
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Dave]

On Mon, Sep 23, 2013 at 12:33 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc linux-pci, linux-kernel, dri-devel]
>
> On Sat, Sep 21, 2013 at 11:39 AM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=61811
>>
>>             Bug ID: 61811
>>            Summary: kms mode breaks and using radeon.agpmode=-1
>>            Product: Drivers
>>            Version: 2.5
>>     Kernel Version: 3.12
>>           Hardware: All
>>                 OS: Linux
>>               Tree: Fedora
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: PCI
>>           Assignee: drivers_pci@kernel-bugs.osdl.org
>>           Reporter: bruno@wolff.to
>>         Regression: No
>>
>> I need to use radeon.agpmode=-1 with my rv280 based graphics card due to a long
>> (2+ years) standing bug with the driver. Recently I was no longer able to start
>> X because modesetting is no longer working. At boot I no longer see the
>> resolution change and I got log entries later in Xor.0.log saying "[KMS] drm
>> report modesetting isn't supported."
>> If I boot without radeon.agpmode=-1 X starts, though becomes unusable shortly
>> due to the pre-existing but. kernel-PAE-3.12.0-0.rc0.git22.2.fc21.i686 works
>> for me. kernel-PAE-3.12.0-0.rc0.git24.1.fc21.i686 doesn't work. (git23's build
>> failed so I didn't test that one.)
>> I did a git whatchanged d5d04bb..3711d86 which I think should have showed me
>> the commits that were in git24 and not git22 and I didn't see any specifically
>> directed at the radeon driver. I did see some PCI related commits.
>
> Thanks for the report!  Can you attach the complete dmesg logs from
> the working kernel and the failing one (booted with
> "radeon.agpmode=-1") to the bugzilla?  Also the output of "lspci -vv".

I don't see any obvious PCI issue there, so I reassigned the bugzilla
to the video folks.

Bjorn
