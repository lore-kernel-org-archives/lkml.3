Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263AbaJ2Pxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:53:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61207 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933467AbaJ2Pxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:53:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ACPI/EC: Fix regressions on Samsung hardware.
Date: Wed, 29 Oct 2014 17:14:29 +0100
Message-ID: <3707792.PHiIGtcpHx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1414553399.git.lv.zheng@intel.com>
References: <544CE637.7000406@odi.ch> <cover.1414553399.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2014 11:33:33 AM Lv Zheng wrote:
> It is reported that the Samsung EC firmware behaves differently than Acer
> EC firmware. And then previous 2 commits that fix Acer issues have broken
> Samsung hardware.
> 
> This patchset fixes the regressions.
> 
> Lv Zheng (2):
>   Revert "ACPI / EC: Add support to disallow QR_EC to be issued before
>     completing previous QR_EC"
>   ACPI/EC: Fix a regression caused by conflict firmware behavior
>     between Samsung and Acer.

Both patches applied, thanks Lv!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
