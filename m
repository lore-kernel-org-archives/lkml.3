Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaE1Cma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:42:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:49752 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaE1Cm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:42:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,924,1392192000"; 
   d="scan'208";a="545920680"
Subject: Re: [PATCH 0/8] Enable dma driver for MIC X100 Coprocessors.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Dan Williams <dan.j.williams@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Siva Yerramreddy <yshivakrishna@gmail.com>
In-Reply-To: <20140527211429.GB18588@kroah.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
	 <1398363008.6542.1.camel@siva-rh63@ra.intel.com>
	 <1399518657.34016.23.camel@localhost>  <20140527211429.GB18588@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 May 2014 19:34:45 -0700
Message-ID: <1401244485.4911.6.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 14:14 -0700, Greg Kroah-Hartman wrote:
> On Wed, May 07, 2014 at 08:10:57PM -0700, Sudeep Dutt wrote:
> > On Thu, 2014-04-24 at 11:10 -0700, Siva Krishna Yerramreddy wrote:
> > > On Mon, 2014-04-14 at 13:14 -0700, Siva Yerramreddy wrote:
> > > > I am sending all these patches to char-misc because there is a dependency
> > > > between the patches for dma driver and other drivers.
> > > > 
> > > Greg, any feedback on the patches?
> > 
> > Hi Greg,
> > The primary author of this patch series Siva is no longer with Intel so
> > we will be taking ownership of addressing review feedback.
> 
> Care to resend these with an author email address that will not bounce?
> I don't like taking code from people with invalid email addresses...
> 

Sure, I have resent the patch series. Please take a look.

Thanks,
Sudeep Dutt

