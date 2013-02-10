Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab3BJXIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:08:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59619 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab3BJXIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:08:22 -0500
Date: Sun, 10 Feb 2013 18:08:18 -0500 (EST)
Message-Id: <20130210.180818.1981510882315670043.davem@davemloft.net>
To: lenb@kernel.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH 04/16] sparc idle: rename pm_idle to sparc_idle
From: David Miller <davem@davemloft.net>
In-Reply-To: <3a242f58a5f40c60568cb1e3b13f119432203f48.1360475150.git.len.brown@intel.com>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
	<2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
	<3a242f58a5f40c60568cb1e3b13f119432203f48.1360475150.git.len.brown@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <lenb@kernel.org>
Date: Sun, 10 Feb 2013 00:58:11 -0500

> From: Len Brown <len.brown@intel.com>
> 
> (pm_idle)() is being removed from linux/pm.h
> because Linux does not have such a cross-architecture concept.
> 
> sparc uses an idle function pointer in its architecture
> specific code.  So we re-name sparc use of pm_idle to sparc_idle.
> 
> Maybe some day, SPARC will cut over to cpuidle...
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
