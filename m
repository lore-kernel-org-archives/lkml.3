Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3CGKUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:20:20 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62727 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3CGKUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:20:18 -0500
X-Nat-Received: from [202.181.97.72]:51485 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1362651596.14985
Message-Id: <201303071019.r27AJscm006917@www262.sakura.ne.jp>
Subject: Re: [PATCH] do not try to sync identity map for non-mapped pages
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: bp@alien8.de, hpa@linux.intel.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Mar 2013 19:19:54 +0900
References: <20130306231009.D782087E@kernel.stglabs.ibm.com>
In-Reply-To: <20130306231009.D782087E@kernel.stglabs.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 07032013 #9676031, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> I have reproduced this bug and this patch fixes it for me
> 
>      https://lkml.org/lkml/2013/2/5/396
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

This patch fixes it for me too.

Thank you.
