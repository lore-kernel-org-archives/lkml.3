Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaDVQNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:13:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42001 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbaDVQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:13:17 -0400
Date: Tue, 22 Apr 2014 12:13:15 -0400 (EDT)
Message-Id: <20140422.121315.929124038777369470.davem@davemloft.net>
To: nasa4836@gmail.com
Cc: nhorman@tuxdriver.com, tj@kernel.org, daniel.wagner@bmw-carit.de,
        gaofeng@cn.fujitsu.com, stephen@networkplumber.org, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netprio_cgroup: explicitly init the early_init field
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHz2CGWfwx+SOTurpW2fO4LsB08tp2ANw+k6aa6bGL=15LNScQ@mail.gmail.com>
References: <1398144722-9864-1-git-send-email-nasa4836@gmail.com>
	<20140422111906.GD17116@hmsreliant.think-freely.org>
	<CAHz2CGWfwx+SOTurpW2fO4LsB08tp2ANw+k6aa6bGL=15LNScQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 22 Apr 2014 09:13:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 19:25:41 +0800

> I don't think that the value of one field(early_init) has a so subtle
> restrition on the another field(css_alloc) is a good thing, but since
> it is there, docment it should be needed.

This is not a reasonable change.

We depend upon implicit initialization to zero all over the kernel,
and adding explicit assignments hurts rather then helps.
