Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaIXUvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:51:08 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56245 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaIXUvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:51:05 -0400
Date: Wed, 24 Sep 2014 14:50:54 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140924205054.GB12407@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <54230093.2060303@linux.vnet.ibm.com>
 <20140924175940.GI8898@obsidianresearch.com>
 <201409242239.41379.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201409242239.41379.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:39:41PM +0200, Peter Hüwe wrote:
 
> If it is more or less a no-op since we have set
> chip->vendor.duration[TPM_SHORT] for other code to work, we can show
> the values for TPM2.0.

It is not a no-op, Jarkko created a whole new file for the tpm2 sysfs
interface, so the two timeout prints are duplicated code from the tpm1
sysfs interface.

Mind you, not sure if we need separate sysfs files ...

Jason
