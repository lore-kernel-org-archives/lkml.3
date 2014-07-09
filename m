Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaGIX2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:28:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaGIX2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:28:22 -0400
Date: Wed, 9 Jul 2014 16:32:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: devres: Sort managed interfaces
Message-ID: <20140709233248.GA12171@kroah.com>
References: <1404919578-4457-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404919578-4457-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 05:26:18PM +0200, Geert Uytterhoeven wrote:
> Sort the list of managed interfaces and their lists of methods
> alphabetically, to reduce the risk of merge conflicts and duplicates.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I got annoyed by the merge conflicts when merging several for-next
> branches a while ago, so I sorted the list after everything became
> quiet.
> ---
>  Documentation/driver-model/devres.txt | 108 +++++++++++++++++-----------------
>  1 file changed, 54 insertions(+), 54 deletions(-)

What tree/version is this against?  I get merge issues with my
driver-core-next tree :(

thanks,

greg k-h
