Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaEHJ3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:29:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaEHJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:29:52 -0400
Date: Thu, 8 May 2014 02:27:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: Re: [PATCH 0/8] Enable dma driver for MIC X100 Coprocessors.
Message-ID: <20140508092743.GD27651@kroah.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
 <1399518657.34016.23.camel@localhost>
 <CAPcyv4g90avzU=d1t21vwY7dea4fAQWvMmZ5Z+tWmHAnFnuFyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g90avzU=d1t21vwY7dea4fAQWvMmZ5Z+tWmHAnFnuFyg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 08:33:20PM -0700, Dan Williams wrote:
> On Wed, May 7, 2014 at 8:10 PM, Sudeep Dutt <sudeep.dutt@intel.com> wrote:
> > On Thu, 2014-04-24 at 11:10 -0700, Siva Krishna Yerramreddy wrote:
> >> On Mon, 2014-04-14 at 13:14 -0700, Siva Yerramreddy wrote:
> >> > I am sending all these patches to char-misc because there is a dependency
> >> > between the patches for dma driver and other drivers.
> >> >
> >> Greg, any feedback on the patches?
> >
> > Hi Greg,
> > The primary author of this patch series Siva is no longer with Intel so
> > we will be taking ownership of addressing review feedback.
> >
> > The patches have been applied to the MIC GITHUB tree which is registered
> > with Fengguang Wu's 0-day infrastructure and no issues have been
> > reported.
> >
> > We have not received any feedback on the patches yet and were wondering
> > if you had a chance to review them?
> 
> Fwiw, I'm still planning on reviewing these.

They are in my queue, sorry, it's really big at the moment due to
travel...


greg k-h
