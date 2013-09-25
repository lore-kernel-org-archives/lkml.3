Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3IYWLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:11:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3IYWLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:11:50 -0400
Date: Wed, 25 Sep 2013 15:11:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add exFAT driver
Message-ID: <20130925221149.GA32760@kroah.com>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
 <20130830154205.GA1411@kroah.com>
 <20130925183632.08a0d073@rechenknecht2k7>
 <20130925172704.GB5258@kroah.com>
 <20130925235721.12d2fcec@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925235721.12d2fcec@rechenknecht2k7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 11:57:21PM +0200, Benjamin Valentin wrote:
> Am Wed, 25 Sep 2013 10:27:04 -0700
> schrieb Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> 
> > > > Also, I would really like to get a signed-off-by: from the Samsung
> > > > authors for this patch, can you do that as well please?
> > > 
> > > I've tried reaching them by their last public e-mail addresses I
> > > could find, but they would either bounce or I got no reply.
> > 
> > Who did you contact at Samsung?  I'll be visiting there in a week so I
> > can try to track some people done in person.  I really want their
> > signed-off-by: on the patch, as it is their code to start with, and
> > it's a bit rude to not get their approval for the code to be merged.
> 
> I didn't really know who to contact at Samsung, so I've searched the web
> for Joosun Hahn and Sung-Kwan Kim. They both had addresses from the
> Memory & Storage Architecture Lab at Seoul National University, but
> they seem no longer active.
> I've also tried the inquiry form on the Samsung web page, but got no
> reply.

Ok, I'll try to track the people responsible for this down when I visit.
In the mean time, you can continue to work on cleaning up the code :)

thanks,

greg k-h
