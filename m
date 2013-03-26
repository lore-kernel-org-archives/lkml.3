Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab3CZWBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:01:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:40010 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab3CZWBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:01:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="312314666"
Date: Tue, 26 Mar 2013 23:01:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11 V4] mei: bus: Initial MEI Client bus type
 implementation
Message-ID: <20130326220137.GA32371@zurbaran>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
 <1363819469-696-2-git-send-email-tomas.winkler@intel.com>
 <20130325202855.GA21494@kroah.com>
 <20130326133326.GA19511@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326133326.GA19511@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 02:33:26PM +0100, Samuel Ortiz wrote:
> On Mon, Mar 25, 2013 at 01:28:55PM -0700, Greg KH wrote:
> > On Thu, Mar 21, 2013 at 12:44:19AM +0200, Tomas Winkler wrote:
> > >  create mode 100644 Documentation/misc-devices/mei/mei-client-bus.txt
> > 
> > Shouldn't you also create Documentation/ABI/ entries as well?
> You mean for the bus specific stuff or for the /dev/mei entry ?
> For the bus parts, we're not adding any MEI specific sysfs entries. What
> should we document ?
I'm adding a modalias sysfs attribute, so I'll have to add an ABI
documentation entry for that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
