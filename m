Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbbA2LDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:03:51 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:63885 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbA2LDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:03:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Behan Webster <behanw@converseincode.com>
Cc: JBottomley@parallels.com, jayamohan.kallickal@emulex.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi, be2iscsi, LLVMLinux: Add missing MODULE_DEVICE_TABLE()
Date: Thu, 29 Jan 2015 12:03:38 +0100
Message-ID: <1959928.K6oPOZ8N2K@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422495422-25281-1-git-send-email-behanw@converseincode.com>
References: <1422495422-25281-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:iHX6w5HWyoya8U8t4ucxTuNuHbp12n8s+X5IvPiiqcExOll2lVX
 fXkw+D+DeMqVI2XNLoWM6xicn9LRvWZmHVXRaJB9VOE7QlZSg7TJJsTybK/ZC6bogFgwT3X
 s90qo8lkLWci56WBhxGtOGJQJtfw6FCKu22NRiopAfelA6ywwHFQfpvgQywOOtBpEOj4xJx
 Kj2SkO7KpErkJmhBqSs1A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 17:37:02 Behan Webster wrote:
> Missing MODULE_DEVICE_TABLE for pci ids from be2iscsi driver found by clang.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---

Like one previous patch, the change is good, the description is wrong.
This patch removes a duplicate MODULE_DEVICE_TABLE entry.

	Arnd
