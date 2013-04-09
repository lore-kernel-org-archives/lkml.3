Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936712Ab3DIQ3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:29:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49009 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764934Ab3DIQ3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:29:49 -0400
Message-ID: <1365524988.6865.55.camel@joe-AO722>
Subject: Re: [PATCH v3 1/1] Introduce Intel RAPL cooling device driver
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 09 Apr 2013 09:29:48 -0700
In-Reply-To: <20130409160741.GA8080@kroah.com>
References: <1365511578-30453-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
	 <20130409152638.GA3033@kroah.com> <1365522817.6865.33.camel@joe-AO722>
	 <20130409160741.GA8080@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 09:07 -0700, Greg Kroah-Hartman wrote:
> On Tue, Apr 09, 2013 at 08:53:37AM -0700, Joe Perches wrote:
> > On Tue, 2013-04-09 at 08:26 -0700, Greg Kroah-Hartman wrote:
> > > On Tue, Apr 09, 2013 at 05:46:18AM -0700, Jacob Pan wrote:
> > > > +#define DEBUG
> > > Why?  I think you need to remove this line :)
> > 
> > Some people like their dev_dbg statements to
> > be emitted all the time.
> 
> Those people should not be submitting new drivers for inclusion in the
> kernel tree.

I think age of code (with some obvious exceptions) isn't
too much of a reliable indicator and adding new
CONFIG_<foo>_DEBUG controls isn't all that great a way
to enable debugging.


