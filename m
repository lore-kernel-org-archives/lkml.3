Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaIXUQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:16:16 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:45522 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaIXUQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:16:15 -0400
Date: Wed, 24 Sep 2014 14:16:06 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/12] tpm: TPM2 support for tpm_pcr_read()
Message-ID: <20140924201606.GB10887@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-4-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924165320.GD8898@obsidianresearch.com>
 <20140924194323.GE6801@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924194323.GE6801@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:43:23PM +0300, Jarkko Sakkinen wrote:

> What do you think about the way trusted module builds messages? It's
> easier to maintain and debug than the approach used in the tpm
> subsystem.

Do you have a source reference?

In my userspace TPM work I use a code generator to produce all the
marshal/unmarshal/AUTH directly from the TPM specification text. The
full generality of TPM RPCs is sufficiently complex that hand coding
is too error prone. The handful of ops the kernel does is not so bad
though...

Jason
