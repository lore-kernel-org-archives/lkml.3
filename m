Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3CLK6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3CLK6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:58:17 -0400
Date: Tue, 12 Mar 2013 06:58:21 -0400 (EDT)
Message-Id: <20130312.065821.925816158187962930.davem@redhat.com>
To: silviupopescu1990@gmail.com
Cc: netdev@vger.kernel.org, geert@linux-m68k.org, joe@perches.com,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet: amd: use PTR_RET instead of IS_ERR + PTR_ERR
From: David Miller <davem@redhat.com>
In-Reply-To: <1363074487-21248-1-git-send-email-silviupopescu1990@gmail.com>
References: <1363074487-21248-1-git-send-email-silviupopescu1990@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date: Tue, 12 Mar 2013 09:48:07 +0200

> This uses PTR_RET instead of IS_ERR and PTR_ERR in order to increase
> readability.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Applied.
