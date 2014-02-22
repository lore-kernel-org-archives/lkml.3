Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaBVI6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 03:58:18 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59933 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaBVI6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 03:58:16 -0500
Message-ID: <530866A2.7080804@redhat.com>
Date: Sat, 22 Feb 2014 09:58:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] kvm: Use pci_enable_msix_exact() instead of pci_enable_msix()
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com> <5304B09D.7010900@redhat.com> <20140221170414.GM17353@dhcp-26-207.brq.redhat.com> <20140221170504.GN17353@dhcp-26-207.brq.redhat.com> <530788C1.6030109@redhat.com> <20140221185620.GA18725@dhcp-26-207.brq.redhat.com> <5307C6D9.4030503@redhat.com> <20140222085030.GA26794@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140222085030.GA26794@dhcp-26-207.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/02/2014 09:50, Alexander Gordeev ha scritto:
> Commit d158fc7 ("Merge tag 'pci-v3.14-fixes-1'") in Linus's tree has it.
>
> pci_enable_msix() is going to be removed once all drivers updated with
> new interface.
>
>> > So, do I have to pull something (which I'd rather not, since pulling
>> > the wrong thing in a submaintainer tree will make Linus angry), or
>> > should I do it in the next merge window after pci_enable_msix_exact
>> > gets in?
> So it is already in.

It is not, because maintainer branches are not rebased.  KVM development 
is based on 3.14-rc1, and will not get that commit until the first 3.15 
pull request is sent to Linux.

No big deal, I'll include this patch in a second 3.15 pull request.

Paolo
