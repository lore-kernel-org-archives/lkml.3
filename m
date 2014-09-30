Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaI3WTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:19:43 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:49911 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaI3WTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:19:41 -0400
Date: Tue, 30 Sep 2014 15:19:40 -0700
From: Zach Brown <zab@zabbo.net>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 1/3] btrfs: replace open-coded kernel_write
Message-ID: <20140930221940.GG12900@lenny.home.zabbo.net>
References: <cover.1412114127.git.osandov@osandov.com>
 <a6e4b5480b7e16bfcac28156381ba33fc8662570.1412114127.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6e4b5480b7e16bfcac28156381ba33fc8662570.1412114127.git.osandov@osandov.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 03:01:40PM -0700, Omar Sandoval wrote:
> write_buf used by btrfs send has what is more or less a reimplementation of
> kernel_write. This also gets rid of a sparse address space warning.

Seems reasonable to me:

Reviewed-by: Zach Brown <zab@zabbo.net>

- z
