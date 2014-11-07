Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaKGTa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:30:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaKGTaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:30:55 -0500
Date: Fri, 7 Nov 2014 11:30:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: mathieu.poirier@linaro.org
Cc: linux@arm.linux.org.uk, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, kaixu.xia@linaro.org, marcin.jabrzyk@gmail.com,
        r.sengupta@samsung.com, robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/12] coresight: add CoreSight core layer framework
Message-ID: <20141107193054.GB29311@kroah.com>
References: <1415038066-22423-1-git-send-email-mathieu.poirier@linaro.org>
 <1415038066-22423-2-git-send-email-mathieu.poirier@linaro.org>
 <20141107193016.GA29311@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107193016.GA29311@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:30:16AM -0800, Greg KH wrote:
> On Mon, Nov 03, 2014 at 11:07:35AM -0700, mathieu.poirier@linaro.org wrote:
> > From: Pratik Patel <pratikp@codeaurora.org>
> > 
> > CoreSight components are compliant with the ARM CoreSight
> > architecture specification and can be connected in various
> > topologies to suit a particular SoC tracing needs. These trace
> > components can generally be classified as sources, links and
> > sinks. Trace data produced by one or more sources flows through
> > the intermediate links connecting the source to the currently
> > selected sink.
> > 
> > The CoreSight framework provides an interface for the CoreSight trace
> > drivers to register themselves with. It's intended to build up a
> > topological view of the CoreSight components and configure the
> > correct serie of components on user input via sysfs.
> > 
> > For eg., when enabling a source, the framework builds up a path
> > consisting of all the components connecting the source to the
> > currently selected sink(s) and enables all of them.
> > 
> > The framework also supports switching between available sinks
> > and provides status information to user space applications
> > through the debugfs interface.
> > 
> > Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> You don't seem to document the sysfs files you create here in
> Documentation/ABI/ anywhere in the series.  Can you fix that up?
> 
> Other than that minor nit, this looks good to me.  Feel free to take it
> through some random ARM tree.

Wait, did you want me to take this through my tree?  If so, I'll be glad
to do so, I can't remember what we talked about here...

thanks,

greg k-h
