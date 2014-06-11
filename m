Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaFKORi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:17:38 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34330 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932186AbaFKORh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:17:37 -0400
Message-ID: <1402496254.2523.3.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [ANNOUNCE] scsi patch queue tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 07:17:34 -0700
In-Reply-To: <20140611120143.GA26071@infradead.org>
References: <20140519140614.GA12183@infradead.org>
	 <20140611120143.GA26071@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 05:01 -0700, Christoph Hellwig wrote:
> After this first pull for the 3.16 merge window it seems like this
> worked out fairly well - we got a large number of patches in, and all
> reviewed by a second pair of eyes.
> 
> How should we go on from this?  The drivers-for-3.16-2 branch, which had
> the late lpfs and hpsa updates didn't make it into the pull request for
> Linus, do you intend to skip them for this window?  If not do you still
> want to have another branch for the other pending smaller updates?

No, I was waiting to check if there was any reason to have them split,
but I think we've scope today or tomorrow.

The only other outstanding thing is the fsync bug fix, which is waiting
Jens' investigation of the block issues it may cause, but I'm inclined
to send it anyway and fix up block later if there's a problem.

James


