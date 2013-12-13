Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3LMPoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:44:22 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:60693 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3LMPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:44:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUHSF4YCQR7DmCZPSviBGDxVdot9vYPVZtTnLMBgviLow@mail.gmail.com>
References: <20131127184652.GA1856@kroah.com> <CAErSpo46LZP8t+aLnYOtJ1mXKKkCF7sOy97MFd0hWo+OOoz68Q@mail.gmail.com>
 <CAE9FiQUeyxN5OAaXqfhdQkzTwjV83BN-L3r6kH0sO0t1b1-63Q@mail.gmail.com>
 <CAErSpo6_s6-Dc__-AzausBVDvOAY5beh7ivng2dWHUN1iRyj+g@mail.gmail.com>
 <20131213020620.GF13333@kroah.com> <CAErSpo6F_oLE2XLt9q5iQE3izuP1ZKW_rib60KKokaL9ewZogA@mail.gmail.com>
 <CAE9FiQUHSF4YCQR7DmCZPSviBGDxVdot9vYPVZtTnLMBgviLow@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 13 Dec 2013 08:43:56 -0700
Message-ID: <CAErSpo4b69MLo6b=hH7Esum94abmki6sZDhvK8eRg0_u8K4-QA@mail.gmail.com>
Subject: Re: [PATCH] PCI: export MSI mode using attributes, not kobjects
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:59 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Dec 12, 2013 at 8:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> No problem.  I have
>>
>> CONFIG_LOCKDEP_SUPPORT=y
>> CONFIG_LOCKDEP=y
>> CONFIG_DEBUG_LOCKDEP=y
>>
>> and I still don't see the problem booting the qemu q35 model.
>> Whatever, I folded it in anyway.
>
> Does qemu q35 use MSI?

Oops, sorry, I *do* see the problem on qemu q35.  I must have messed
something up when I tried it yesterday.  And I verified that your
change fixes it.  Sorry for the noise.

Bjorn
