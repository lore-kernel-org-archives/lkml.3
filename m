Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3LPLBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:01:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24534 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3LPLBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:01:52 -0500
Message-ID: <52AEDD94.90100@oracle.com>
Date: Mon, 16 Dec 2013 16:31:40 +0530
From: Allen Pais <allen.pais@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 1/3] sparc64: use generic rwsem spinlocks rt
References: <1387166853-10782-1-git-send-email-allen.pais@oracle.com> <1387166853-10782-2-git-send-email-allen.pais@oracle.com> <52AED56B.2090102@linutronix.de>
In-Reply-To: <52AED56B.2090102@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> davem won't apply this because the PREEMPT_RT symbol is not available
> upstream. I referred to patch two+.

Yes, I thought it'd be good get a  review from him.

- Allen

