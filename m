Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaCKMcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:32:09 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:59877 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbaCKMcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:32:06 -0400
Date: Tue, 11 Mar 2014 08:32:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Silvan Jegen <s.jegen@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] pata_legacy: Remove dead code
Message-ID: <20140311123202.GC11477@htj.dyndns.org>
References: <531e3c9a.085e0e0a.4316.ffffe91d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531e3c9a.085e0e0a.4316.ffffe91d@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:33:50PM +0100, Silvan Jegen wrote:
> The current flow of control prevents this function from being
> called. Let's remove the call.
> 
> Signed-off-by: Silvan Jegen <s.jegen@gmail.com>

Applied to libata/for-3.15.

Thanks.

-- 
tejun
