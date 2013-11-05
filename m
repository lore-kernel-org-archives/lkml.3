Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3KLNt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:49:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab3KLNt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:49:26 -0500
Date: Tue, 5 Nov 2013 10:43:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Aldo Iljazi <mail@aldo.io>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: fixed coding style issues
Message-ID: <20131105094354.GD16999@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Aldo Iljazi <mail@aldo.io>,
	chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1383634921-4271-1-git-send-email-mail@aldo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383634921-4271-1-git-send-email-mail@aldo.io>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 09:02:01AM +0200, Aldo Iljazi wrote:
> Line 4989: Inserted a space after the comma.
> Lines 7986 and 8274: Inserted a space before the open parenthesis.

Hm, I don't know why my message from yesterday did not make it to the
list, but I'm objecting against flow of such changes that are not always
actual changes (replacing spaces by tabs). We don't really need them at
this point of development phase of btrfs.

The style issues should be fixed when a patch is being merged, doing it
afterwards increases patch history and makes digging in history
unnecessarily tedious.

There are lots of opportunities to do actual code cleanup, whitespaces
are just noise.

david
