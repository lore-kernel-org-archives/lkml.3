Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbaGYGsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:48:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58997 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGYGsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:48:20 -0400
Date: Thu, 24 Jul 2014 23:48:18 -0700 (PDT)
Message-Id: <20140724.234818.2188537379553418401.davem@davemloft.net>
To: therbert@google.com
Cc: aaron.lu@intel.com, linux-kernel@vger.kernel.org, lkp@01.org
Subject: Re: [LKP] [net] 11ef7a8996d: +27.3% netperf.Throughput_Mbps
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+mtBx-26J=r_aH0Y72ghRhDpUCbEzRxkrA1Xmtame_msHKnUQ@mail.gmail.com>
References: <53d1f50b.CEZoGFBjN5Kgc+zm%fengguang.wu@intel.com>
	<53D1F9B5.8050500@intel.com>
	<CA+mtBx-26J=r_aH0Y72ghRhDpUCbEzRxkrA1Xmtame_msHKnUQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Jul 2014 23:48:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Herbert <therbert@google.com>
Date: Thu, 24 Jul 2014 23:37:07 -0700

> Are you pointing out a regressions in this?

I think he's letting you know that performance has improved, in fact :)
