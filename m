Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3DSH0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:26:21 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:45658 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab3DSH0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:26:19 -0400
Date: Fri, 19 Apr 2013 09:26:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Aravind <aravind.gopalakrishnan@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: Re: [PATCH V4] edac: Handle EDAC ECC errors for Family 16h
Message-ID: <20130419072615.GB20897@gmail.com>
References: <1366228633-3159-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130417212022.GA9181@pd.tnic>
 <516F41FF.8000202@amd.com>
 <20130418090800.GA21719@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418090800.GA21719@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Apr 17, 2013 at 07:44:47PM -0500, Aravind wrote:
> > For some reason, this hunk does not apply cleanly..
> > I tried this: (moving the line)
> > 
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
> > 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
> > 	{}
> 
> I swapped that in your patch because wanted to have those sorted. We're
> probably using different trees though..
> 
> > and this seems to work..
> > Otherwise, I tested the patch and it works.
> 
> Ok, good.
> 
> Thanks.

Ok, mind resending the last version with all acks/signoff included?

Thanks,

	Ingo
