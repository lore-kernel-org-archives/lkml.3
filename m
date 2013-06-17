Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3FQXix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:38:53 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:36341 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3FQXiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:38:51 -0400
Date: Tue, 18 Jun 2013 01:38:02 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, juan.david.gonzalez.cobas@cern.ch,
        cota@braap.org, siglesias@igalia.com, rob@landley.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/8] FMC: add core bus driver
Message-ID: <20130617233802.GA17517@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20130617231606.GB12984@kroah.com>
References: <20130617231606.GB12984@kroah.com>
  <cover.1371018406.git.rubini@gnudd.com>
  <3e9f6b2fb7cd202da9bbb6371b27ff302ca8b860.1371018406.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> + * Released according to the GNU GPL, version 2 or any later version.
> 
> I have to ask, do you really mean "or any later version"?

Yes, it was intended. I don't think it's an issue for merging, but
I understand you've seen so many such undesired copy-paste errors.

>> +EXPORT_SYMBOL(fmc_driver_unregister);
> 
> Any specific reason these aren't EXPORT_SYMBOL_GPL()?
> 
> Again, just have to ask.

I think we want to allow for proprietary FMC drivers. I personally
don't feel this is a core kernel technology.  But I'll let David Cobas
expand on CERN policies, as I'm only a consultant.

thanks
/alessandro
