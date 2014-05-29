Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbaE2KUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:20:38 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:36929 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaE2KUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:20:37 -0400
Date: Thu, 29 May 2014 12:20:25 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Yong Zhang <yong.zhang@windriver.com>, huawei.libin@huawei.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>
Subject: Re: [PATCH V2] MIPS: change type of asid_cache to unsigned long
Message-ID: <20140529102025.GF5157@linux-mips.org>
References: <1400650563-1033-1-git-send-email-yong.zhang@windriver.com>
 <5384119E.7010606@huawei.com>
 <20140528200929.GA30528@drone.musicnaut.iki.fi>
 <5386F663.4010401@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386F663.4010401@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 04:57:07PM +0800, Li Zefan wrote:

> I don't think Ralf has committed it, so we'll send out a fix
> with detailed changelog.

It's queued to go upstream, commit e5eb925a1804c4a52994ba57f4f68ee7a9132905.

  Ralf
