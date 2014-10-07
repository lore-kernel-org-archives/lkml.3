Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaJGSCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:02:25 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38716 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbaJGSCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:02:23 -0400
Date: Tue, 7 Oct 2014 12:02:09 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Huewe <PeterHuewe@gmx.de>,
        keyrings@linux-nfs.org, jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [TrouSerS-tech] [Ksummit-discuss] TPM MiniSummit @
 LinuxCon Europe
Message-ID: <20141007180209.GD10432@obsidianresearch.com>
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
 <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
 <543428E1.7050702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543428E1.7050702@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:54:41PM -0400, Stefan Berger wrote:

> Why add the complexity of swapping of authenticated sessions and keys 
> into the kernel if you can handle this in userspace? You need a library 
> that is aware of the number of key slots and slots for sessions in the 
> TPM and swaps them in at out when applications need them. Trousers is 
> such a library that was designed to cope with the limitations of the 
> device and make its functionality available to all applications that 
> want to access it.

How does trousers work with the kernel when the kernel is also using
TPM key slots for IMA/keyring/whatever?

Jason
