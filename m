Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaHDS6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:58:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37821 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaHDS6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:58:05 -0400
X-Greylist: delayed 4156 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2014 14:58:05 EDT
Date: Mon, 4 Aug 2014 13:48:31 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Hariprasad S <hariprasad@chelsio.com>
Cc: linux-firmware@kernel.org, ben@decadent.org.uk, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: linux-firmware: update cxgb4 firmware
Message-ID: <20140804174831.GB20672@merlin.infradead.org>
References: <20140627120910.GA2406@hariprasad-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627120910.GA2406@hariprasad-pc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 05:39:11PM +0530, Hariprasad S wrote:
> Hi,
> 
> Can you please pull from the following URL?
>     git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> 

Trying to pull this for you right now... git.chelsio.net seems to be
offline though.

regards, Kyle

> The following changes since commit 7f388b4885cf64d6b7833612052d20d4197af96f:
> Ben Hutchings (1):
>     Move the s5p-mfc firmware out of its subdirectory
> 
> are available in the git repository at:
> 
> git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> 
> Hariprasad Shenai (1):
>     cxgb4: Update firmware to revision 1.11.27.0
> 
>     LICENCE.chelsio_firmware |    2 +-
>     WHENCE                   |    8 ++++----
>     cxgb4/t4fw-1.11.27.0.bin |  Bin 0 -> 512512 bytes
>     cxgb4/t4fw-1.9.23.0.bin  |  Bin 486912 -> 0 bytes
>     cxgb4/t4fw.bin           |    2 +-
>     cxgb4/t5fw-1.11.27.0.bin |  Bin 0 -> 513024 bytes
>     cxgb4/t5fw-1.9.23.0.bin  |  Bin 481280 -> 0 bytes
>     cxgb4/t5fw.bin           |    2 +-
>     8 files changed, 7 insertions(+), 7 deletions(-)
>     create mode 100644 cxgb4/t4fw-1.11.27.0.bin
>     delete mode 100644 cxgb4/t4fw-1.9.23.0.bin
>     create mode 100644 cxgb4/t5fw-1.11.27.0.bin
>     delete mode 100644 cxgb4/t5fw-1.9.23.0.bin
> 
