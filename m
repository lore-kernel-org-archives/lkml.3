Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaAOAIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:08:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:16407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaAOAIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:08:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="334290325"
Date: Tue, 14 Jan 2014 16:13:35 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Add Clovertrail and Merrifeld support to Intel MID
Message-ID: <20140115001335.GA18183@psi-dev26.jf.intel.com>
References: <1387224459-25746-1-git-send-email-david.a.cohen@linux.intel.com>
 <20140114224419.GB9834@psi-dev26.jf.intel.com>
 <52D5CDA1.3050306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D5CDA1.3050306@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:52:01PM -0800, H. Peter Anvin wrote:
> On 01/14/2014 02:44 PM, David Cohen wrote:
> > On Mon, Dec 16, 2013 at 12:07:35PM -0800, David Cohen wrote:
> >> Hi,
> >>
> >> I've a bunch of Intel MID patches under review but it seems they are becoming
> >> old and start to need changes.
> >> I gathered an up-to-date version of all of them in this single patch set.
> >>
> >> This series implements support of Clovertrail and Merrifield to Intel MID.
> >> It also removes the unwanted X86_MDFLD option since *all* Intel MID platforms
> >> should be supported through CONFIG_X86_INTEL_MID option.
> >>
> >> This makes obsolete the following patches:
> >> https://lkml.org/lkml/2013/10/18/480
> >> https://lkml.org/lkml/2013/10/22/533
> >> http://lkml.indiana.edu/hypermail/linux/kernel/1311.1/02937.html
> > 
> > Ping :)
> > Any comments on this whole patch set?
> > 
> 
> You got some feedback from Bjorn and Ingo... mostly description-related,
> but that is important enough.

Hm. I believe I sent new patch versions based on those comments. But I
guess I failed to spot my new patches were my reply :(

Br, David

> 
> Other than that we should queue it up ASAP.
> 
> 	-hpa
> 
