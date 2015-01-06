Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbbAFXX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:23:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57234 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbbAFXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:23:28 -0500
Date: Tue, 06 Jan 2015 18:23:23 -0500 (EST)
Message-Id: <20150106.182323.1215139731992886345.davem@davemloft.net>
To: fkan@apm.com
Cc: patches@apm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] net: eth: xgene: change APM X-Gene SoC platform
 ethernet to support ACPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420584093-19236-1-git-send-email-fkan@apm.com>
References: <1420584093-19236-1-git-send-email-fkan@apm.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 15:23:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Kan <fkan@apm.com>
Date: Tue,  6 Jan 2015 15:41:33 -0700

> This adds support for APM X-Gene ethernet driver to use ACPI table to derive
> ethernet driver parameter.
> 
> Signed-off-by: Feng Kan <fkan@apm.com>

Applied.
