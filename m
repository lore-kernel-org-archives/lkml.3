Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3FRRku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:40:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3FRRks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:40:48 -0400
Date: Tue, 18 Jun 2013 10:40:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        cota@braap.org, siglesias@igalia.com, rob@landley.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/8] FMC: add core bus driver
Message-ID: <20130618174047.GA21738@kroah.com>
References: <cover.1371018406.git.rubini@gnudd.com>
 <3e9f6b2fb7cd202da9bbb6371b27ff302ca8b860.1371018406.git.rubini@gnudd.com>
 <20130617231606.GB12984@kroah.com>
 <20130617233802.GA17517@mail.gnudd.com>
 <CADDK0KdrVgmXN-TZw8E43JRNk5Wb_cfM6pUWaSxbJ49GU72cTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADDK0KdrVgmXN-TZw8E43JRNk5Wb_cfM6pUWaSxbJ49GU72cTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 09:30:00AM +0200, Juan David Gonzalez Cobas wrote:
> Hi all,
> 
> On Tue, Jun 18, 2013 at 1:38 AM, Alessandro Rubini <rubini@gnudd.com> wrote:
> 
>     [...]
> 
>  
> 
>     Yes, it was intended. I don't think it's an issue for merging, but
>     I understand you've seen so many such undesired copy-paste errors.
> 
> 
> CERN policies favour GPLv3 as default open source license as a recommendation.
> The "GPLv2 or later" is, in effect, intentional.

Ok, thanks for verifying this.

>     >> +EXPORT_SYMBOL(fmc_driver_unregister);
>     >
>     > Any specific reason these aren't EXPORT_SYMBOL_GPL()?
>     >
>     > Again, just have to ask.
> 
>     I think we want to allow for proprietary FMC drivers. I personally
>     don't feel this is a core kernel technology.  But I'll let David Cobas
>     expand on CERN policies, as I'm only a consultant.
> 
> 
> CERN policies (mostly recommendations) concern esp. the return of
> investment of taxpayer money to society. In view of the potential use
> cases of FMC, EXPORT_SYMBOL_GPL would better serve that
> purpose than merely allowing proprietary modules, so GPL exports
> are fine.

Great.

Alessandro, care to respin the patches that I didn't apply and resend
them so that I can?

thanks,

greg k-h
