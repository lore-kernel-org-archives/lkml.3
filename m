Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3JDRIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:08:17 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:43748 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3JDRIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:08:15 -0400
Date: Fri, 4 Oct 2013 11:08:03 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Joel Schopp <jschopp@linux.vnet.ibm.com>
Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Rajiv Andrade <mail@srajiv.net>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Sirrix AG <tpmdd@sirrix.com>,
        Richard Maciel Costa <richardm@br.ibm.com>,
        "trousers-tech@lists.sourceforge.net" 
	<trousers-tech@lists.sourceforge.net>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to
 sysfs into tpm-sysfs.c
Message-ID: <20131004170803.GB6955@obsidianresearch.com>
References: <52408E5D.4020904@tycho.nsa.gov>
 <20130923193633.GA9194@obsidianresearch.com>
 <5240A2A3.4040102@tycho.nsa.gov>
 <20130923204232.GB16345@obsidianresearch.com>
 <5240BA0E.3000304@tycho.nsa.gov>
 <20130923222324.GA9533@obsidianresearch.com>
 <5241A199.1080505@tycho.nsa.gov>
 <20130930181005.GG28898@obsidianresearch.com>
 <5249E0CB.2070106@tycho.nsa.gov>
 <5249F6AF.7050608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5249F6AF.7050608@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 05:09:51PM -0500, Joel Schopp wrote:

> > So far, nobody I have talked to has offered any strong opinions on
> > what locality should be used or how it should be set. I think finding
> > a developer of trousers may be the most useful to talk about how the
> > ioctl portion of this would need to be set up - if someone is actually
> > needed.

> I am a TrouSerS developer and am ccing Richard, another TrouSerS
> developer, and ccing the trousers-tech list.  It would be good if you
> could elaborate on the question and context for those not following the
> entire thread, myself included.

Two questions:

Is userspace interested in using the TPM Locality feature, and if so
is there any thoughts on what the interface should be?

Is the kernel interested in using the TPM Locality feature? What for?

Jason
