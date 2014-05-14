Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaENTFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:05:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53406 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaENTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:05:42 -0400
Date: Wed, 14 May 2014 15:05:40 -0400 (EDT)
Message-Id: <20140514.150540.789420080702346332.davem@davemloft.net>
To: dave@sr71.net
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        siva.kallam@samsung.com, vipul.pandya@samsung.com, ks.giri@samsung.com,
        joe@perches.com, bh74.an@samsung.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: driver: samsung: keep off in Kconfig by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140514182416.106B1904@viggo.jf.intel.com>
References: <20140514182416.106B1904@viggo.jf.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 May 2014 12:05:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@sr71.net>
Date: Wed, 14 May 2014 11:24:16 -0700

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> These are a pet peeve of mine: Kconfig options that very few
> people need turned on, but that default to y.
> 
> I know that this doesn't generate any code by itself, but it
> does get in the way of every single person that does an
> oldconfig.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

The general policy we have is that VENDOR guards are on by default.
