Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaJVIkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:40:51 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41116 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaJVIkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:40:49 -0400
Date: Wed, 22 Oct 2014 01:40:45 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: [PATCH V2 linux-next] jffs2: fix sparse warning: unexpected
 unlock
Message-ID: <20141022084045.GI16128@brian-ubuntu>
References: <1411932392-7751-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411932392-7751-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 09:26:32PM +0200, Fabian Frederick wrote:
> fs/jffs2/summary.c:846:5: warning: context imbalance in 'jffs2_sum_write_sumnode' - unexpected unlock
> 
> Suggested-by: Brian Norris <computersforpeace@gmail.com>
> Suggested-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2: use __must_hold instead of __releases / __acquires
> (suggested by Brian Norris and Josh Triplett)

Pushed to l2-mtd.git. Thanks!

Brian
