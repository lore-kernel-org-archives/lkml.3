Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaCFOqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:46:47 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:53241 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaCFOqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:46:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140306070047.GF16859@needle.mulix.org>
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
	<20140305053617.GE26240@dhcp-17-89.nay.redhat.com>
	<20140306064756.GB16859@needle.mulix.org>
	<53181AC1.2020807@zytor.com>
	<20140306070047.GF16859@needle.mulix.org>
Date: Thu, 6 Mar 2014 07:46:44 -0700
Message-ID: <CAPoiz9yhAeoWDANus6=O_5AomKFEAzzR1pR4F0rN2HnDWwYAMg@mail.gmail.com>
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
From: Jon Mason <jdmason@kudzu.us>
To: Muli Ben-Yehuda <muli@cs.technion.ac.il>
Cc: "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>,
        kexec@lists.infradead.org, discuss@x86-64.org, x86@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 12:00 AM, Muli Ben-Yehuda <muli@cs.technion.ac.il> wrote:
> On Wed, Mar 05, 2014 at 10:50:41PM -0800, H. Peter Anvin wrote:
>
>> OK, second question... is it time to axe Calgary?
>
> I don't know of anyone still using it, but it's not
> impossible. Calgary and CalIOC2 machines would now be ~5-8 years old.

It is getting a bit crufty in arch/x86.  Would it be better to move it
to drivers/iommu?

>
> Cheers,
> Muli
