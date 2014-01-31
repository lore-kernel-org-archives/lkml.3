Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaAaIEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:04:36 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:33783 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbaAaIEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:04:34 -0500
Date: Fri, 31 Jan 2014 08:04:28 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140131080428.GA29136@console-pimps.org>
References: <20140124183730.GC11788@pd.tnic>
 <20140124184842.GD11788@pd.tnic>
 <20140124191709.GT18196@sgi.com>
 <20140127222129.GK6839@pd.tnic>
 <20140128110552.GA815@pd.tnic>
 <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130221950.GJ3105@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan, at 04:19:50PM, Alex Thorlton wrote:
> Re-adding lkml.
 
Also add linux-efi.

> The quick answer is I think it is a virtual address, because
> it does not work in physical mode.  If you ever see "virtefi"
> on the RHEL bootline it is because RH switched the default
> to physical mode, which caused UV to not boot.  "virtefi"
> forced it back to virtual mode.

Do you have details of the failure, links to bug reports? Is it a
limitation of the firmware?

-- 
Matt Fleming, Intel Open Source Technology Center
