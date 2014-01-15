Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaAOSX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:23:58 -0500
Received: from fieldses.org ([174.143.236.118]:38446 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbaAOSXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:23:54 -0500
Date: Wed, 15 Jan 2014 13:23:47 -0500
To: Jan Kara <jack@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Message-ID: <20140115182347.GB5715@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-12-git-send-email-miklos@szeredi.hu>
 <20140113122517.GA10366@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113122517.GA10366@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 01:25:17PM +0100, Jan Kara wrote:
>   I think this deserves a comment that RENAME_EXCHANGE expects both source
> and target to exist... I'm always pondering about this condition before I
> realize that.

Do you have a man page update somewhere for the two new flags?

--b.
