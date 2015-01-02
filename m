Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbbABVk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:40:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53833 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbbABVkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:40:22 -0500
Date: Fri, 02 Jan 2015 16:40:19 -0500 (EST)
Message-Id: <20150102.164019.754021420669768265.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: benve@cisco.com, ssujith@cisco.com, _govind@gmx.com, neepatel@cisco.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: cisco: enic: enic_dev: Remove some
 unused functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420230564-2060-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420230564-2060-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Jan 2015 13:40:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Fri,  2 Jan 2015 21:29:24 +0100

> Removes some functions that are not used anywhere:
> enic_dev_enable2_done() enic_dev_enable2() enic_dev_deinit_done()
> enic_dev_init_prov2() enic_vnic_dev_deinit()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
