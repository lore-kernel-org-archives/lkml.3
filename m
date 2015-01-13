Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbbAMW2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:28:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36824 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAMW2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:28:02 -0500
Date: Tue, 13 Jan 2015 17:27:59 -0500 (EST)
Message-Id: <20150113.172759.1913310752123595264.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: lanai: Remove unused function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421174719-5371-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1421174719-5371-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Jan 2015 14:28:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 13 Jan 2015 19:45:19 +0100

> Remove the function aal5_spacefor() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
