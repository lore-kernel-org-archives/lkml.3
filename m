Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaIHS7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:59:34 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:51595 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaIHS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:59:33 -0400
Date: Mon, 8 Sep 2014 21:59:23 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Nitin Kuppelur <nitinkuppelur@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: octeon-hcd: removed unwanted return from void
 functions
Message-ID: <20140908185923.GA10550@drone.musicnaut.iki.fi>
References: <1410196395-4595-1-git-send-email-nitinkuppelur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410196395-4595-1-git-send-email-nitinkuppelur@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 07:13:15PM +0200, Nitin Kuppelur wrote:
> This is a patch to the octeon-hcd.c file that fixes checkpatch.pl warning by removing return statement from void functions.

Please format line length to <= 76 characters in the commit log.

Maybe you could fix __cvmx_usb_perform_complete() as well?

A.
