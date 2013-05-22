Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3EVFcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:32:11 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55269 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3EVFcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <519C40A8.1070506@huawei.com>
References: <1367743225-3484-1-git-send-email-libo.chen@huawei.com>
	<519C40A8.1070506@huawei.com>
Date: Wed, 22 May 2013 07:32:07 +0200
Message-ID: <CACna6rxaBGLVsMzckr5+XLgVoZAH0m-Hz73C6OmXay4vT+_fKA@mail.gmail.com>
Subject: Re: [PATCH RESEND] mtd: fix kfree bcm47xxsflash
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com, wfp5p@virginia.edu,
        hauke@hauke-m.de, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/22 Libo Chen <clbchenlibo.chen@huawei.com>:
> mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash  not its member.

Thanks!

-- 
Rafał
