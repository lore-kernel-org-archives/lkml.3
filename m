Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3FCUjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:39:48 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:36675 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab3FCUjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:39:46 -0400
Date: Mon, 3 Jun 2013 13:39:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: timur@tabi.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        clemens@ladisch.de, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v4] ata: increase retry count but shorten duration for
 Calxeda controller
Message-ID: <20130603203941.GC29989@mtj.dyndns.org>
References: <1369842679-9680-1-git-send-email-mark.langsdorf@calxeda.com>
 <1370265774-13939-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370265774-13939-1-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 08:22:54AM -0500, Mark Langsdorf wrote:
> Increase the retry count for the hard reset function to 100 but
> shorten the time out period to 500 ms. See the comment for
> ahci_highbank_hardreset for the reasons why those vaulues were
> chosen.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>

Applied to libata/for-3.10-fixes w/ stable cc'd.

Thanks!

-- 
tejun
