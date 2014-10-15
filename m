Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaJOPqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:46:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51889 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaJOPqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:46:43 -0400
Date: Wed, 15 Oct 2014 11:46:39 -0400 (EDT)
Message-Id: <20141015.114639.1870406278699948300.davem@davemloft.net>
To: peppe.cavallaro@st.com
Cc: netdev@vger.kernel.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH (net.git) 1/1] stmmac: fix sti compatibililies
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413351041-11369-1-git-send-email-peppe.cavallaro@st.com>
References: <1413351041-11369-1-git-send-email-peppe.cavallaro@st.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Oct 2014 08:46:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Date: Wed, 15 Oct 2014 07:30:41 +0200

> this patch is to fix the stmmac data compatibilities for
> all the SoCs inside the platform file.
> 
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

Please in the future provide a proper "Reported-by: " tag for people
like Stephen who let you know about the problem.

Applied, thanks.
