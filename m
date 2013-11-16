Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3KPBSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 20:18:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49406 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752148Ab3KPBSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 20:18:07 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, rui.zhang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/AC: Remove the pointer of struct acpi_device in the struct acpi_ac
Date: Sat, 16 Nov 2013 02:30:40 +0100
Message-ID: <16311253.HBP6ZcGIE6@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1384313262-20029-1-git-send-email-tianyu.lan@intel.com>
References: <1384313262-20029-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 13, 2013 11:27:42 AM Lan Tianyu wrote:
> Now the pointer of struct acpi_device can be got by
> ACPI_COMPANION(struct acpi_ac->pdev->dev). So the pointer
> is not necessary and remove it.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Queued up for the next ACPI pull request, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
