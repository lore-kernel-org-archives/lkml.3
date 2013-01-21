Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3AUVw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:52:27 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:41974 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3AUVw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:52:26 -0500
Date: Tue, 22 Jan 2013 01:52:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Kinney, Steven" <Steven.Kinney@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] AMD IOMMUv2 PC resource management hooks
Message-ID: <20130121215222.GK25252@moon>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
 <1358799658-6236-3-git-send-email-steven.kinney@amd.com>
 <20130121213218.GI25252@moon>
 <57D41218901B4442B4AFF404D21591163B9FAD@sausexdag02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57D41218901B4442B4AFF404D21591163B9FAD@sausexdag02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 09:47:30PM +0000, Kinney, Steven wrote:
> Hi Cyrill,
> Agree, will clean this up.

Yeah, but no rush. Lets wait for other opinions as well.
