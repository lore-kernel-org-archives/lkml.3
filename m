Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3KTPnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:43:33 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61528 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3KTPna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:43:30 -0500
Date: Wed, 20 Nov 2013 10:43:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 04/29] PCI/MSI/pSeries: Make quota traversing and
 requesting race-safe
Message-ID: <20131120154326.GD28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <663c95d5c7c6863f248886add511dab83f15dd18.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <663c95d5c7c6863f248886add511dab83f15dd18.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry about the long delay.  Was traveling quite a bit.

On Fri, Oct 18, 2013 at 07:12:04PM +0200, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Please explain what the race condition in detail and how it gets fixed
by the patch.  This isn't a trivial change and non-trivial changes
especially stuff like race condition fixes definitely require detailed
explanation.

Thanks.

-- 
tejun
