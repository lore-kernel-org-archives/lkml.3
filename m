Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3HCAwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:52:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3HCAwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:52:37 -0400
Date: Sat, 3 Aug 2013 08:53:36 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "Brown, Len" <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC v01 0/3] Power Capping Framework
Message-ID: <20130803005336.GB31696@kroah.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
 <20130802222909.GA28831@kroah.com>
 <51FC4635.1040909@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FC4635.1040909@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 04:52:21PM -0700, Srinivas Pandruvada wrote:
> On 08/02/2013 03:29 PM, Greg KH wrote:
> >On Fri, Aug 02, 2013 at 11:08:49AM -0700, Srinivas Pandruvada wrote:
> >>- A uniform sys-fs interface for all devices which can offer power capping
> >There is no "-" in sysfs please.
> OK.
> >>- A common API for drivers, which will avoid code duplication and easy
> >>implementation of client drivers.
> >>
> >>Once this framework is approved, we will submit a RAPL client driver using this
> >>framework.
> >No, you need users of a framework in order for it to be approved, we
> >don't add infrastructure without users.
> >
> >Especially as what usually happens is, when you add actual users, the
> >framework changes to fix the bugs found in it :)
> I will post the one client driver, which is already using this
> framework as this series.
> >Ideally you will have more than one client driver submitted, as a
> >"framework" for just one driver seems a bit odd, don't you think?
> There are other groups and vendors interested in using this
> framework. But they want to make sure that this
> framework can go to upstream Linux. We will provide one client using
> this framework at this time.
> Do you think this is a problem?

I would love to see the feedback from those groups and vendors as well,
to ensure that they agree with this.  Ideally, they would sign off on
the patches, and provide clients that work with the framework at the
same time.  Otherwise, I just have to take your word for it :)


> >Also, you add lots of new sysfs files, those need to be documented in
> >Documentation/ABI/ with this series.
> I have a Documentation patch, which describes ABI and framework. It
> is under Documentation/powercap.
> Do I need to move this to Documentation/ABI?

The files in that directory need to follow the format that is described
in Documentation/ABI/README.  I suggest keeping the file you currently
have, and also adding entries into the ABI/ subdirectory as well.

thanks,

greg k-h
