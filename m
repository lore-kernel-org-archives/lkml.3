Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaDDIcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:32:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaDDIcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:32:43 -0400
Date: Fri, 4 Apr 2014 09:32:32 +0100
From: =?iso-8859-1?Q?Lu=EDs?= Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3.5 71/71] ioat: fix tasklet tear down
Message-ID: <20140404083232.GA3464@hercules>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
 <1396272197-13394-72-git-send-email-luis.henriques@canonical.com>
 <1396570392.22689.90.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396570392.22689.90.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 01:13:12AM +0100, Ben Hutchings wrote:
> On Mon, 2014-03-31 at 14:23 +0100, Luis Henriques wrote:
> > 3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ben Hutchings <ben@decadent.org.uk>
> [...]
> 
> Should be From: Dan Williams <dan.j.williams@intel.com>
> 
> I think you must have got my name by applying the 3.2 review mail...
> 
> Ben.
> 
> -- 
> Ben Hutchings
> If you seem to know what you are doing, you'll be given more to do.

Ups, thanks for catching that.  It's now fixed.

Cheers,
--
Luís
