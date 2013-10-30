Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3J3Qwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:52:35 -0400
Received: from imap.thunk.org ([74.207.234.97]:52507 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab3J3QvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:51:00 -0400
Date: Wed, 30 Oct 2013 07:36:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] ext4: pair trace_ext4_writepages &
 trace_ext4_writepages_result
Message-ID: <20131030113603.GA12186@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <1382012926-398-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382012926-398-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 08:28:46PM +0800, Ming Lei wrote:
> Pair the two trace events to make troubeshooting writepages
> easier, and it should be more convinient to write a simple script
> to parse the traces.

Applied, thanks!!

					- Ted
