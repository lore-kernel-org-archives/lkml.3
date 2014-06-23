Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaFWQPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:15:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbaFWQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:15:14 -0400
Date: Mon, 23 Jun 2014 12:15:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 22/22] vme: bridges: Use pci_zalloc_consistent
Message-ID: <20140623161503.GB20288@kroah.com>
References: <cover.1403530604.git.joe@perches.com>
 <19d9cd323d43bdb25425356d87e50de23855a1d4.1403530604.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19d9cd323d43bdb25425356d87e50de23855a1d4.1403530604.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:41:50AM -0700, Joe Perches wrote:
> Remove the now unnecessary memset too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/vme/bridges/vme_ca91cx42.c | 6 ++----
>  drivers/vme/bridges/vme_tsi148.c   | 6 ++----
>  2 files changed, 4 insertions(+), 8 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
