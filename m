Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbaKTMzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:55:01 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:53354 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKTMzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:55:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH] ARM: multi_v7_defconfig: Enable cgroups
Date: Thu, 20 Nov 2014 13:54:52 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1416254107-29326-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1416254107-29326-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201411201354.52679.arnd@arndb.de>
X-Provags-ID: V02:K0:LDu4qHrEW853mwtK/X1zIlRHtOSzdC4CC5yymaaM9G1
 qpeUaDyDlFzg7Ae8pVxiEcGIqivB19cFvAcceSQVUhl/Rk6JzL
 cvZh5GNrxhDdRenJuufDNqz+7ST8kGoyz7CbNtCU7eiqtDDq1V
 XZuHQ1tC2PUl5MA4G+4W7TjyJoDGyPUz4PBeBzMa5gzQjXmB7w
 zmlNg6O/5ws+FWkiZmh8DwdKq3GQOnZAs6Ukquf/BBZGxyIrfV
 wCBimPltXzeYqEiNr+DvoamiHaKA6/DQ0Y8ZPOVuk+T35U6r4e
 WvlnDRWsgqZP6Lh13N4zoasDXop9bbqDPbzF3u4YF/UuiMq1tr
 SHafkQTqn3LO7ufdMF7hBkxTGmSQ9of/G39ZV4Jjf
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014, Soren Brinkmann wrote:
> This allows booting the kernel with systemd-based root file systems.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> Hi,
> 
> I don't know whether I'm the only one, but I use a initramfs with
> systemd as init, which requires cgroup support in the kernel to fully
> boot.
> 

You probably are at this time, but I expect it to get more common
in the future, I don't think enabling this is controversial at all.

Applied to next/defconfig, thanks!

	Arnd
