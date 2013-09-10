Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3IJVxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:53:48 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:41509 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3IJVxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:53:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUUyqY_FHCRZQ0aHu+2V-yqqdD1YVRp5rHnULBMY7BUfA@mail.gmail.com>
References: <1361182193-31894-1-git-send-email-hare@suse.de>
 <CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com>
 <5124820D.2080900@suse.de> <CAE9FiQXHteymDNzu0GqWtVSVhu3g2hCT+K9e5tB1mR-OBX1ffA@mail.gmail.com>
 <5125C45A.5020208@suse.de> <CAErSpo5j3Qge5Q2S+hyMGOcmoN77V0T=1+6OJdNJfJdnvT8wgg@mail.gmail.com>
 <51305B99.6080806@suse.de> <20130305224150.GE8339@xanatos>
 <CAErSpo4nAN7wFaRebw5fM3gQVppaQoSSh3PdFumgCS1SGhcxcw@mail.gmail.com> <CAE9FiQUUyqY_FHCRZQ0aHu+2V-yqqdD1YVRp5rHnULBMY7BUfA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 10 Sep 2013 15:53:25 -0600
Message-ID: <CAErSpo64gJUanHkw4chsynHG0YZ=81X5TDbcLe8ZVsr2JMk4CQ@mail.gmail.com>
Subject: Re: [PATCH] pci: do not try to assign irq 255
To: Yinghai Lu <yinghai@kernel.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, Oliver Neukum <oneukum@suse.de>,
        David Haerdeman <david@hardeman.nu>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andy Grover <agrover@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 5:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Mar 26, 2013 at 2:54 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>> Where are we at with this?  I don't see Sarah's patch in the tree, and
>> I haven't applied any changes, so my guess is this is still broken.
>
> Yes, the fix is in the linus tree.
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=00eed9c814cb8f281be6f0f5d8f45025dc0a97eb

Thanks, Yinghai.

Frederik, can you confirm that
https://bugzilla.kernel.org/show_bug.cgi?id=52591 is fixed by the
change above?

Bjorn
