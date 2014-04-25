Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaDYPAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:00:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52198 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbaDYPAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:00:50 -0400
Message-ID: <1398438048.2159.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: two small scsi fixes for 3.15-rc3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Fri, 25 Apr 2014 08:00:48 -0700
In-Reply-To: <1398424190-21325-1-git-send-email-hch@lst.de>
References: <1398424190-21325-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 13:09 +0200, Christoph Hellwig wrote:
> Hi Linus, hi James,
> 
> these are two simple use after free fixes that fix a regression introduced
> by me in the first scsi update for 3.15-rc1.
> 
> I've sent them to the scsi list 10 days ago and haven't seen any reply to
> them, and I'd hate if they miss -rc3 in addition to -rc2.

You should have received my git tree emails that they were already in
SCSI fixes ... didn't you?  I certainly got a copy.

James


