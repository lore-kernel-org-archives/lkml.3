Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaJUKLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:11:15 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63812 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaJUKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:11:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jingchang Lu <jingchang.lu@freescale.com>, gregkh@linuxfoundation.org,
        peter@hurleysoftware.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, josephl@nvidia.com
Subject: Re: [PATCH] serial: of-serial: fix uninitialized kmalloc variable
Date: Tue, 21 Oct 2014 12:11:08 +0200
Message-ID: <2601201.5ptAsr65zc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413881421-9554-1-git-send-email-jingchang.lu@freescale.com>
References: <1413881421-9554-1-git-send-email-jingchang.lu@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cvLQCrR1SV/MEj+oO7t+gbWo538RSyGhxQF/GJwl7PD
 lqXP7gRjLyQGlyrFlJbqMtb14X8P8ulzg9WyqB1PdXdYrXNIil
 tfJ/k7IL17fOcDpe/2N9skLRGSHGlcxIeoK/th2WkRScz3hJuV
 CnK2jYczrrl0JLr/ixoQtiNM4PZ8FntJs8Q887+xP3DhmYNBTr
 OfkNw8vOXWGQ+T/JaUoSRpvS2JpdlwLdDDFkmhUAYeRc9aqsi4
 LJy2ZsfUksusAc1tFE9V1hccl6QSihATIVA3T9/yykqbpFZoZ1
 mXGcQIHhWzCzKUw66QDkBggu/4sKILpdMq+wjIpe5LZmAIkaHC
 KfiEc1RRj3Sng8z6vIVs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 16:50:21 Jingchang Lu wrote:
> The info pointer points to an uninitialized kmalloced space.
> If a device doesn't have clk property, then info->clk may
> have unpredicated value and cause call trace. So use kzalloc
> to make sure it is NULL initialized.
> 
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de
