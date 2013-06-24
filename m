Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3FXXmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:42:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3FXXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:42:41 -0400
Date: Mon, 24 Jun 2013 16:42:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jeff Mahoney <jeffm@suse.com>, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-usb@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Michal Marek <mmarek@suse.cz>, tomi.valkeinen@ti.com
Subject: Re: [PATCH] build some drivers only when compile-testing
Message-ID: <20130624234240.GA21064@kroah.com>
References: <1369214326-6558-1-git-send-email-jslaby@suse.cz>
 <20130523022327.GB6159@kroah.com>
 <519D8876.9050405@suse.com>
 <51BF6BFF.7050705@suse.cz>
 <20130618160427.GE28961@kroah.com>
 <51C154A0.6080104@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C154A0.6080104@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 08:50:08AM +0200, Jiri Slaby wrote:
> On 06/18/2013 06:04 PM, Greg Kroah-Hartman wrote:
> >> So currently I have what is attached... Comments?
> > 
> > Looks good to me, want me to queue it up through my char/misc driver
> > tree for 3.11?
> 
> If there are no objections... Whoever picks that up, I would be happy 8-).

I've taken it, without the chipidea portion, through my driver-core
tree.

thanks,

greg k-h
