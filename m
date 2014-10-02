Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaJBNnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:43:11 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56783 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaJBNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <1412255137-28954-1-git-send-email-marti@juffo.org>
References: <1412255137-28954-1-git-send-email-marti@juffo.org>
From: Marti Raudsepp <marti@juffo.org>
Date: Thu, 2 Oct 2014 16:42:38 +0300
Message-ID: <CABRT9RCxNy99A4L3vkb=Xha6hG71QtVenB2QiMdcKtUJikepCw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Add ACS support for AMD A88X southbridge devices
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Kernel hackers <linux-kernel@vger.kernel.org>
Cc: Joel Schopp <joel.schopp@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 4:05 PM, Marti Raudsepp <marti@juffo.org> wrote:
> Joel Schopp at https://bugzilla.kernel.org/show_bug.cgi?id=81841#c15
>>     +-14.4-[01]----05.0  Dialogic Corporation PRI
>> The legacy PCI should be isolated from the other devices identified.
>> Not sure what is going on here.
>>
>>     +-14.5  Advanced Micro Devices, Inc. [AMD] FCH USB OHCI Controller
>> This OHCI Controller should also be isolated from the other devices.

To clarify, I realize the phrases "Not sure what is going on here" and
"should also be isolated" don't inspire much confidence, but I have
not managed to obtain more concrete statements in the bugzilla entry
for a month and a half. So I decided to try and push it.

I guess that the integrated devices 0000:00:15.2 (Ethernet) and
0000:00:15.3 (USB host controller) should also be isolated, but again,
I have no evidence, and it's not relevant to my use case.

Regards,
Marti Raudsepp
