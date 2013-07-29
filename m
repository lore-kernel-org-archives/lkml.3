Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3G2P7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:59:23 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:34778 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab3G2P7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:59:16 -0400
Date: Mon, 29 Jul 2013 11:59:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>
Subject: Re: [PATCH] ATA: sata_mv: Remove unneeded forward declaration
Message-ID: <20130729155910.GB22605@mtj.dyndns.org>
References: <1375111282-22624-1-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375111282-22624-1-git-send-email-ezequiel.garcia@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 12:21:21PM -0300, Ezequiel Garcia wrote:
> These forward declarations are no longer needed, and are probably
> historical left-over.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Applied to libata/for-3.12.

Thanks.

-- 
tejun
