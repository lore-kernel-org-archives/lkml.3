Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaFKHPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:15:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42967 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaFKHPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:15:37 -0400
Date: Wed, 11 Jun 2014 00:15:36 -0700 (PDT)
Message-Id: <20140611.001536.384904520252789239.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wimax: i2400m: control.c: Cleaning up conjunction
 always evaluates to false
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402140397-17404-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402140397-17404-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Jun 2014 00:15:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sat,  7 Jun 2014 13:26:37 +0200

> Logical conjunction always evaluates to false:  minor < 2 && minor > 1
> I guess what you wanted is rather: minor > 2 || minor < 1
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
