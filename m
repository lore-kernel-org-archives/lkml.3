Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaHKOkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:40:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaHKOki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:40:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dm: propagate QUEUE_FLAG_NO_SG_MERGE
References: <x49iom3hvle.fsf@segfault.boston.devel.redhat.com>
	<20140811011108.GA13946@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 11 Aug 2014 10:40:20 -0400
In-Reply-To: <20140811011108.GA13946@redhat.com> (Mike Snitzer's message of
	"Sun, 10 Aug 2014 21:11:08 -0400")
Message-ID: <x49mwbbozsb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer <snitzer@redhat.com> writes:

> Hi Jeff,
>
> Thanks for the patch.  But I think you need the following tweak.
> Otherwise if the DM table is reloaded (and the devices in the table
> happen to change) the flag won't get cleared as needed.

Ah, thanks for the education.  Looks good to me.

Thanks!
Jeff
