Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3FKRMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:12:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3FKRMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:12:43 -0400
Date: Tue, 11 Jun 2013 19:12:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Kent Overstreet <koverstreet@google.com>
Cc: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH 22/26] block: Make generic_make_request handle arbitrary
 sized bios
Message-ID: <20130611171241.GA5316@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
	Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
	tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
 <1370744348-15407-23-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370744348-15407-23-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 07:19:04PM -0700, Kent Overstreet wrote:
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -467,6 +468,7 @@ struct request_queue {
>  #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
>  #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
>  #define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
> +#define QUEUE_FLAG_LARGEBIOS   19	/* no limits on bio size */
                                  ^^
				  20 ?

david
