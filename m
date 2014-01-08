Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbaAHVng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:43:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaAHVnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:43:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 5/6] power: reset: change xgene reboot driver to use both acpi and dts resource for reboot.
Date: Wed, 8 Jan 2014 22:43:01 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Feng Kan <fkan@apm.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1389135041-16062-1-git-send-email-fkan@apm.com> <1389135041-16062-6-git-send-email-fkan@apm.com>
In-Reply-To: <1389135041-16062-6-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401082243.01694.arnd@arndb.de>
X-Provags-ID: V02:K0:D3Iwhe53uUgBseNCmRFJwxvydqgkYEUvjnu0nfX7/lq
 vGuaN+UrDhio3trO/zeSa76ZrEMVCV1uLzdcgVI2clpDxRVHnq
 SPsM+eVApUXKnkFqWmX/dzGbg0fRk6ntlf3jQuByDcCTFh5pD4
 TLKIpCSGdoRwb0tiqxT7Sr8lPw3l6lqqlBQrIrGTHwA6+n4cnx
 FSf7liOASAWdUnvs1XUeyW0YOxh5xBmL1C8xykTyUftLvROR1G
 AwqgsmeXZFGeq3sog3jj3yFpHcLAdtq8mfKGsjM9l5PXrr6Oiz
 /KZ0bwU1OX7tU9hUxRo2NtUFpC0YFL2p5X7WhSH4i9tEawBqUP
 BEI6LEG2mIBm4rZwzJBs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 January 2014, Feng Kan wrote:
> Enable the X-Gene reboot driver to use either the ACPI or the DTS
> resource using the platform driver method.
> 
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  drivers/power/reset/xgene-reboot.c |   33 ++++++++++++++++++++++++++++-----
>  1 files changed, 28 insertions(+), 5 deletions(-)
> 

Shouldn't an ACPI based system always be able to reboot through the
UEFI reset_system call? I really don't think we want to support
ACPI on non-UEFI systems.

	Arnd
