Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3FRH3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:29:53 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45395 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3FRH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:29:51 -0400
Date: Tue, 18 Jun 2013 00:29:57 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: dts: msm: Fix merge resolution
Message-ID: <20130618072957.GC21138@quad.lixom.net>
References: <1371501578-24484-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371501578-24484-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 01:39:38PM -0700, David Brown wrote:
> Commit e45600107b (Merge tag 'msm-cleanup-for-3.11' of
> git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm into
> next/cleanup) incorrectly resolved a merge conflict, resulting in a
> node address that doesn't match the register address.
> 
> Fix this node address.

Luckily this is just cosmetic. Applied.


-Olof
