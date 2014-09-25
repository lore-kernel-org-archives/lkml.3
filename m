Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIYPyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:54:10 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39866 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaIYPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:54:08 -0400
Date: Thu, 25 Sep 2014 09:54:02 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: rdunlap@infradead.org, bp@alien8.de, tony.luck@intel.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heather Brown <hbrown@hp.com>
Subject: Re: [RESEND 0/5] PCIe, AER: Misc cleanup
Message-ID: <20140925155402.GB12200@google.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Heather]

On Wed, Aug 13, 2014 at 02:22:36AM -0400, Chen, Gong wrote:
> 
> No response since last commit so spread it to a bigger range.
> 
> This patch series is for AER related cleanup & update based on PCIe
> SPEC r3.0.

I applied patches 1, 2 (modified as described in my response to it), 3, and
4 to pci/aer for v3.19, thanks!

I didn't apply patch 5 because it apparently doesn't fix a reported bug,
and it has the potential to break hardware that used the PCIe r1.0
definition of the "Training Error" bit.

Bjorn
