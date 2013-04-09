Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937131Ab3DIQHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:07:48 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58114 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937046Ab3DIQHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:07:46 -0400
Date: Tue, 9 Apr 2013 09:07:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v3 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130409160741.GA8080@kroah.com>
References: <1365511578-30453-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <20130409152638.GA3033@kroah.com>
 <1365522817.6865.33.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365522817.6865.33.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 08:53:37AM -0700, Joe Perches wrote:
> On Tue, 2013-04-09 at 08:26 -0700, Greg Kroah-Hartman wrote:
> > On Tue, Apr 09, 2013 at 05:46:18AM -0700, Jacob Pan wrote:
> > > +#define DEBUG
> > Why?  I think you need to remove this line :)
> 
> Some people like their dev_dbg statements to
> be emitted all the time.

Those people should not be submitting new drivers for inclusion in the
kernel tree.
