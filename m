Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaHKV53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 17:57:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59334 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaHKV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 17:57:27 -0400
Date: Mon, 11 Aug 2014 14:57:26 -0700 (PDT)
Message-Id: <20140811.145726.257229777777517083.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: hykim@myri.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: ethernet: myricom: myri10ge: myri10ge.c:
 Cleaning up missing null-terminate after strncpy call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407784696-31698-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1407784696-31698-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 14:57:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 11 Aug 2014 21:18:16 +0200

> Added a guaranteed null-terminate after call to strncpy.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
