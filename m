Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaE0VK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:10:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaE0VK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:10:56 -0400
Date: Tue, 27 May 2014 14:14:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: Re: [PATCH 0/8] Enable dma driver for MIC X100 Coprocessors.
Message-ID: <20140527211429.GB18588@kroah.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
 <1398363008.6542.1.camel@siva-rh63@ra.intel.com>
 <1399518657.34016.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399518657.34016.23.camel@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 08:10:57PM -0700, Sudeep Dutt wrote:
> On Thu, 2014-04-24 at 11:10 -0700, Siva Krishna Yerramreddy wrote:
> > On Mon, 2014-04-14 at 13:14 -0700, Siva Yerramreddy wrote:
> > > I am sending all these patches to char-misc because there is a dependency
> > > between the patches for dma driver and other drivers.
> > > 
> > Greg, any feedback on the patches?
> 
> Hi Greg,
> The primary author of this patch series Siva is no longer with Intel so
> we will be taking ownership of addressing review feedback.

Care to resend these with an author email address that will not bounce?
I don't like taking code from people with invalid email addresses...

thanks,

greg k-h
