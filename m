Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaBMWNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:13:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50620 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaBMWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:13:50 -0500
Date: Thu, 13 Feb 2014 17:13:48 -0500 (EST)
Message-Id: <20140213.171348.584083783987595218.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation/networking: delete orphaned 3c505.txt
 file.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392171574-6231-1-git-send-email-paul.gortmaker@windriver.com>
References: <1392169920-5713-1-git-send-email-paul.gortmaker@windriver.com>
	<1392171574-6231-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 14:13:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 11 Feb 2014 21:19:34 -0500

> In the commit 0e245dbaac9fa1c2fd0f4e2af7b9f6d874083a8b
> ("drivers/net: delete the 3Com 3c505/3c507 intel i825xx support")
> we clobbered the 3c505 driver (over a year ago) along with other
> abandoned ISA drivers.
> 
> However, this orphaned README file escaped detection at that
> time, and has lived on until today. Get rid of it now.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied to 'net', thanks.
