Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3IJNji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:39:38 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36023 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab3IJNjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:39:36 -0400
Message-ID: <1378820374.18893.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] [scsi] enclosure: remove all possible sysfs entries
 before add device
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Date: Tue, 10 Sep 2013 06:39:34 -0700
In-Reply-To: <522E7AF4.9060504@oracle.com>
References: <522D685D.5060201@oracle.com>
	 <20130909134131.GB24738@infradead.org> <522E7AF4.9060504@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 09:50 +0800, Joe Jin wrote:
> On 09/09/13 21:41, Christoph Hellwig wrote:
> >> Modules linked in: oracleacfs(P)(U) oracleadvm(P)(U) oracleoks(P)(U)
> > 
> > Please reproduce without this weird crap loaded.
> > 
> These modules is filesystem and will not impact enclosure.

That's not really something you can guarantee, is it?  Experience has
shown us that binary modules tend to do silly things which can
compromise the integrity of the whole system, so it's not unreasonable
to ask for a reproduction without them, particularly as most kernel
debugging time is volunteer best effort.

In this case the problem looks to be udev and timing related, so having
it reproduced without these modules eliminates a real source of
uncertainty.

James


