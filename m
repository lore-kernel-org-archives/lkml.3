Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaIWODm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:03:42 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:59754 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaIWODk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:03:40 -0400
Date: Tue, 23 Sep 2014 10:03:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: linux-ide <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: change ata_<foo>_printk routines to return void
Message-ID: <20140923140336.GH14905@mtj.dyndns.org>
References: <1411404738.2952.39.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411404738.2952.39.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 09:52:18AM -0700, Joe Perches wrote:
> The return value is not used by callers of these functions nor
> by uses of all macros so change the functions to return void.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to libata/for-3.18.

Thanks.

-- 
tejun
