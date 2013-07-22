Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3GVKFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:05:40 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:56767 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3GVKFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:05:39 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At1pABUD7VFV5qu1PGdsb2JhbABagwaDJoUjuGcEAYENFwMBAQEBODWCJAEBBTocEwEPEAgDFQMJJQ8FJQoaE4gUtlwWjmOBHQeDEG4Dl1yGM44vOg
X-IronPort-AV: E=Sophos;i="4.89,718,1367964000"; 
   d="scan'208";a="584680224"
From: rydberg@euromail.se
Date: Mon, 22 Jul 2013 12:07:13 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 37/72] Input: bcm5974 - add support for the 2013 MacBook Air
Message-ID: <20130722100713.GA1952@polaris.bitmath.org>
References: <20130719052559.852627424@linuxfoundation.org>
 <20130719054445.GA14863@kroah.com>
 <20130722014203.GA31697@kroah.com>
 <68729596.GVj7zRsy2V@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68729596.GVj7zRsy2V@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sun, Jul 21, 2013 at 07:21:29PM -0700, Dmitry Torokhov wrote:
> On Sunday, July 21, 2013 06:42:03 PM Greg Kroah-Hartman wrote:
> > On Thu, Jul 18, 2013 at 10:44:45PM -0700, Greg Kroah-Hartman wrote:
> > > On Thu, Jul 18, 2013 at 10:40:40PM -0700, Dmitry Torokhov wrote:
> > > > Greg,
> > > > 
> > > > On Thu, Jul 18, 2013 at 10:25:54PM -0700, Greg Kroah-Hartman wrote:
> > > > > 3.10-stable review patch.  If anyone has any objections, please let me
> > > > > know.
> > > > > 
> > > > > ------------------
> > > > > 
> > > > > From: Dmitry Torokhov <rydberg@euromail.se>
> > > > 
> > > > Any chance you could change this to read "Henrik Rydberg"? My import
> > > > script messed up. And on hid part as well...
> > > 
> > > Ok, will do.
> > 
> > And I promptly forgot to do this, and I released 3.10.2 with it as-is,
> > sorry about that.
> 
> Oh well, it was my screw up to begin with. Hopefully Henrik is not too annoyed 
> with me.

Well, it's the thought that counts, thanks for trying. As long as
people do not start to mix us up, I am happy. ;-)

Henrik
