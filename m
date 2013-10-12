Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3JLJ0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 05:26:04 -0400
Received: from mail.SerNet.de ([193.175.80.2]:57473 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3JLJ0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 05:26:01 -0400
X-Greylist: delayed 917 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Oct 2013 05:26:01 EDT
Date: Sat, 12 Oct 2013 11:10:11 +0200
Date: Sat, 12 Oct 2013 11:10:11 +0200
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
To: Frank Filz <ffilzlnx@mindspring.com>
Cc: "'Jeff Layton'" <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Reply-To: Volker.Lendecke@SerNet.DE
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
 <20131011093510.7ed9871a@tlielax.poochiereds.net>
 <01f801cec695$7e5d17e0$7b1747a0$@mindspring.com>
 <20131011115006.697d6bd7@tlielax.poochiereds.net>
 <020001cec6a4$601b6f70$20524e50$@mindspring.com>
 <20131011144240.007f96c1@tlielax.poochiereds.net>
 <020301cec6b3$30aa5d00$91ff1700$@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <020301cec6b3$30aa5d00$91ff1700$@mindspring.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <E1VUvDc-00G3xy-4A@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 11:53:30AM -0700, Frank Filz wrote:
> > I guess my main concern is that while I'm interested in adding interfaces
> that
> > make it _easier_ to implement fileservers, I'm not terribly interested in
> > adding interfaces that are _specific_ to implementing them.
> > 
> > Whatever interface we add needs to be generic enough to be useful to other
> > applications as well. The changes you're suggesting sound rather specific
> to a
> > particular use-case.
> 
> Sure, understood, though the Samba folks may have some input here also
> (though at least they have a process per connection still right? So the

Yes, correct. With the changes we have to make to support
SMB3 Multichannel this might change in the near future
tough.

Volker

-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
