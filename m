Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaKKWnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:43:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:33896 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaKKWnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:43:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="620820341"
Date: Tue, 11 Nov 2014 14:42:22 -0800
From: "Sean O. Stalley" <sean.stalley@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [V2 PATCH 03/10] added media agnostic (MA) data structures and
 handling
Message-ID: <20141111224222.GB3415@sean.stalley.intel.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415671781-11351-3-git-send-email-stephanie.s.wallick@intel.com>
 <20141111043821.GD22068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111043821.GD22068@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 01:38:21PM +0900, Greg KH wrote:
> On Mon, Nov 10, 2014 at 06:09:34PM -0800, Stephanie Wallick wrote:
> Intel has a whole group of very experienced Linux kernel developers who
> will review code before you sent it out publicly.  Please take advantage
> of them and run this all through them before resending this out again.
> 
> If you did run this code through that group, please let me know who it
> was specifically that allowed this stuff to get through, and why they
> didn't want their name on this code submission.  I need to have a strong
> word with them...

We submitted the patches for internal review and got no objections to
release. We will be more aggressive in seeking out feedback (and approval)
before resubmitting any code.
 
> Yes, I am holding you to a higher standard than staging code normally
> is, and yes, it is purely because of the company you work for.  But I
> only do that because your company knows how to do this stuff right, and
> you have access to the resources and talent to help make this code
> right.  Other people and companies do not have the kind of advantage
> that you do.

We know we are fortunate to work for a company with so much talent and
resources and we don't mind being held to a higher standard. We have been
receiving multiple requests for our host driver and wanted to make it
available as soon as possible for others to use. We thought putting our
host driver into staging would be a good way to release it, but realize now
that it was premature. 

> Wasting community member's time (i.e. mine) by forcing _them_ to review
> stuff like this, is something that your company knows better than to do,
> as should you as well.
> 
> I want to see some more senior Intel kernel developer's signed-off-by
> lines on this code before I will ever consider accepting it for the
> kernel.  Please do not resend this code until that happens.
> 
> greg k-h

We apologize for wasting everyone's time and will certainly learn from this.
We won't resubmit the driver until a senior kernel developer has signed off on it.

Sincerely,
Sean O. Stalley
Stephanie S. Wallick
