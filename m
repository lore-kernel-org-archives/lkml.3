Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaFWRZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:25:23 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39410 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbaFWRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:25:18 -0400
Date: Mon, 23 Jun 2014 10:25:12 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arch@vger.kernel.org, linux-scsi@vger.kernel.org,
        iss_storagedev@hp.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-crypto@vger.kernel.org, linux-eata@i-connect.net,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 00/22] Add and use pci_zalloc_consistent
Message-ID: <20140623172512.GA1390@garbanzo.do-not-panic.com>
References: <cover.1403530604.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1403530604.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:41:28AM -0700, Joe Perches wrote:
> Adding the helper reduces object code size as well as overall
> source size line count.
> 
> It's also consistent with all the various zalloc mechanisms
> in the kernel.
> 
> Done with a simple cocci script and some typing.

Awesome, any chance you can paste in the SmPL? Also any chance
we can get this added to a make coccicheck so that maintainers
moving forward can use that to ensure that no new code is
added that uses the old school API?

  Luis
