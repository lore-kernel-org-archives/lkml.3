Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3INDel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 23:34:41 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53006 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3INDek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 23:34:40 -0400
X-Nat-Received: from [202.181.97.72]:53809 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379129667.32421
To: khalid.aziz@oracle.com
Cc: jbottomley@parallels.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] SCSI: buslogic: Added check for DMA mapping errors (wasRe:[BusLogic] DMA-API: device driver failed to check map error)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1378816604.6973.53.camel@dabdike.int.hansenpartnership.com>
	<1379004807.10738.3.camel@concerto>
	<201309140042.GEI73439.QHSJtOFFVFOLOM@I-love.SAKURA.ne.jp>
	<52333560.50209@oracle.com>
	<1379101446.8358.4.camel@concerto>
In-Reply-To: <1379101446.8358.4.camel@concerto>
Message-Id: <201309141234.AGC35960.tVOMOOLJFQHFSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 14 Sep 2013 12:34:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14092013 #11049650, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz wrote:
> Added check for DMA mapping errors for request sense data
> buffer. Checking for mapping error can avoid potential wild
> writes. This patch was prompted by the warning from
> dma_unmap when kernel is compiled with CONFIG_DMA_API_DEBUG.

This patch looks OK and works OK to me.

Thank you.
