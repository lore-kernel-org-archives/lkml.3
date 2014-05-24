Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaEXMNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:13:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48013 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbaEXMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:13:42 -0400
Message-ID: <1400933617.6956.34.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] acornscsi: remove linked command support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 24 May 2014 16:13:37 +0400
In-Reply-To: <538075E0.4080001@suse.de>
References: <1400926433.31526.89.camel@x220> <538075E0.4080001@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-24 at 12:35 +0200, Hannes Reinecke wrote:
[...]
> I'm all for it. Removing never-really-implemented feature on obsolete 
> hardware is always a good idea.
> 
> Acked-by: Hannes Reinecke <hare@suse.de>

Wait, no, that's not a good idea.  We leave obsolete drivers to bitrot.
Particularly we try not to touch them unless we have to because there
might be a few people still using them and the more we tamper, the
greater the risk that something gets broken.  On that principle, since
there's no real reason to remove the code, it should stay ... until the
whole driver bitrots to the extent that we can no-longer compile it.

However, I'll do this if the Maintainer (rmk) acks ... because if it
breaks he gets to fix it.

James


