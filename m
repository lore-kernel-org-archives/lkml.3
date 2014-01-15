Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaAONbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:31:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAONbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:31:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Prabhakar Kushwaha <prabhakar@freescale.com>
Subject: Re: [PATCH 1/2][v2] driver/memory:Move Freescale IFC driver to a common driver
Date: Wed, 15 Jan 2014 14:31:35 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, scottwood@freescale.com
References: <1389788003-25442-1-git-send-email-prabhakar@freescale.com>
In-Reply-To: <1389788003-25442-1-git-send-email-prabhakar@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401151431.35731.arnd@arndb.de>
X-Provags-ID: V02:K0:pZVNsF8IhJgk+p+H0MPUEjI9gCT7Kq6mj+2lgkKKo8c
 kqmfOPxLXPzNM0+Ur+acdRNNYYuTkfnUlXW0ni6w6jZkU14lEF
 AIMLFHve49QaYlvNWgAq5XvPcaOZHHdemIBsNirQiDlLaYMZJg
 OZVCGsOi+nDBkNPLh9XB79+mE/OsyL4HlmN/iF1fK745QtO6y9
 RF372BXh/AlXjyURv6xthFW629ixYScM8nOupLkSdrstGRYyJZ
 l9SwOIpRtc83B32dMTPb3dEy3CerjzKLVaKc6iyWF2jmX6svAq
 LmlgmhmMsJAF8dgJF5FtMSExvF/BIghGiUQcJAkRZMOZPSNqke
 MpyPllezrJng3JIIHkVk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014, Prabhakar Kushwaha wrote:
> Freescale IFC controller has been used for mpc8xxx. It will be used
> for ARM-based SoC as well. This patch moves the driver to driver/memory
> and fix the header file includes.
> 
> Also remove module_platform_driver() and  instead call
> platform_driver_register() from subsys_initcall() to make sure this module
> has been loaded before MTD partition parsing starts.
> 
> Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

provided that you also move the binding from powerpc/fsl/ifc.txt to
memory/fsl-ifc.txt.
