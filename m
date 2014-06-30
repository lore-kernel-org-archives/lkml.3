Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaF3Q1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:27:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaF3Q1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:27:33 -0400
Date: Mon, 30 Jun 2014 09:27:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH char-misc-next v2 0/8] Enable dma driver for MIC X100
 Coprocessors
Message-ID: <20140630162718.GE24179@kroah.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
 <1402934289.16234.6.camel@rbtaylor-desk1.amr.corp.intel.com>
 <1404142433.27474.6.camel@rbtaylor-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404142433.27474.6.camel@rbtaylor-desk1.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 08:33:53AM -0700, Sudeep Dutt wrote:
> On Mon, 2014-06-16 at 08:58 -0700, Sudeep Dutt wrote:
> > On Thu, 2014-05-29 at 14:23 -0700, Sudeep Dutt wrote:
> > > ChangeLog:
> > > =========
> > > v1 => v2:
> > > a) MIC bus driver cleanups and device release callback fix in patch 2,
> > >    as per feedback from Greg Kroah-Hartman.
> > > 
> > > v1: Initial post @ https://lkml.org/lkml/2014/5/27/819
> > > 
> > 
> > Hi Greg/Dan,
> > 
> > We have addressed the feedback received so far. Please take a look at
> > this patch series.
> > 
> 
> Another gentle reminder to take a look at this patch series. Greg/Dan,
> please let us know what we can do to speed things up here.

Wait for me to get back from vacation next week :)

greg k-h
