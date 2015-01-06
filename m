Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbbAFDlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:41:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbAFDlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:41:45 -0500
Date: Mon, 05 Jan 2015 22:41:37 -0500 (EST)
Message-Id: <20150105.224137.894770670718334587.davem@davemloft.net>
To: fkan@apm.com
Cc: patches@apm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: eth: xgene: change APM X-Gene SoC platform
 ethernet to support ACPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420508576-10480-1-git-send-email-fkan@apm.com>
References: <1420508576-10480-1-git-send-email-fkan@apm.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Jan 2015 19:41:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Kan <fkan@apm.com>
Date: Mon,  5 Jan 2015 17:42:56 -0800

> This adds support for APM X-Gene ethernet driver to use ACPI table to derive
> ethernet driver parameter.
> 
> Signed-off-by: Feng Kan <fkan@apm.com>

Applied.
