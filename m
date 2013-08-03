Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3HCAzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:55:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3HCAzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:55:31 -0400
Date: Sat, 3 Aug 2013 08:54:18 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Brown, Len" <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC v01 0/3] Power Capping Framework
Message-ID: <20130803005418.GC31696@kroah.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
 <20130802223020.GB28831@kroah.com>
 <51FC48DE.2040000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FC48DE.2040000@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 05:03:42PM -0700, Srinivas Pandruvada wrote:
> On 08/02/2013 03:30 PM, Greg KH wrote:
> >On Fri, Aug 02, 2013 at 11:08:49AM -0700, Srinivas Pandruvada wrote:
> >>Once this framework is approved, we will submit a RAPL client driver using this
> >>framework.
> >Also, given that you work with a lot of kernel developers, I would like
> >to see their review and signed-off-by: on these patches before you
> >resend them, please.  That way I know that they agree with this
> >framework as a way for their future changes in this area.
> The framework was presented internally number of times to Intel
> Linux Architects (including Rafael, Len Brown  and Arjan (copied in
> this email)).

That's good to hear, ideally they would sign off on this as well to show
people like me that they agree with this, otherwise I have no idea that
they have even looked at it.

thanks,

greg k-h
