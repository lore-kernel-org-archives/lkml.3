Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721Ab3LTN2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:28:33 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:34104 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160999Ab3LTN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:28:29 -0500
Date: Fri, 20 Dec 2013 08:28:24 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@aculab.com>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 9/9] PCI/MSI: Introduce pci_auto_enable_msi*() family
 helpers
Message-ID: <20131220132824.GA4298@htj.dyndns.org>
References: <cover.1387140921.git.agordeev@redhat.com>
 <bbf6f73ef3e16e5dfd7d41fc1e4412f641acb0f3.1387140921.git.agordeev@redhat.com>
 <20131218003002.GA15119@google.com>
 <20131218132349.GA29552@dhcp-26-207.brq.redhat.com>
 <CAErSpo6Km5N+Cfpaj5JEsb966rwcBjrAT4SFvG6Q9QkwkDFXCA@mail.gmail.com>
 <20131219134244.GA32238@dhcp-26-207.brq.redhat.com>
 <CAErSpo66Jh-8sbQr13r1LknfKWMt1zBd9xhm46XpCcW-X_TqnA@mail.gmail.com>
 <20131220090412.GA28367@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220090412.GA28367@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 20, 2013 at 10:04:13AM +0100, Alexander Gordeev wrote:
> I can only identify two downsides of the approach above - (a) repeated error
> logging in a platform code (i.e. caused by -ENOMEM) and (b) repeated attempts
> to enable MSI when the platform already reported a fatal error.

I don't think (a) is likely as long as only -ENOSPC is retried, which
also solves (b).

Thanks.

-- 
tejun
