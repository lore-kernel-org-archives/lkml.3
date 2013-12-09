Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab3LIBvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:51:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760118Ab3LIBvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:51:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 0/9] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Mon, 9 Dec 2013 02:51:44 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com> <1386543229-1542-1-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312090251.45207.arnd@arndb.de>
X-Provags-ID: V02:K0:sgFeLdRpn++Uf8NMSvsaAs4jwYwIBrZNqNJxjUkry2I
 KPluy7QfcgTtH+cB8LPv8LYdfU+ZxiXiIAIEsKDtRF10CEq81Z
 hA38w7DZVres+zEdMHuvsatyMHFLsofrUkHtoPyh8aHEtbxS4B
 CsoNnwZA971rU3lvG+erZD2rObpLlm4zzeHpMcUYAtEoaDzuwt
 W9V+7opyZcMgPf7fLv7/Q2chQTAIZVF8u2lnd17FCP7h/Q4+2k
 fwlUhwrurcTzD1XXkcL90FyzqSCPFOXmxwB63mWnEtzw9dDp3q
 dULN+rQWYQ5/3qw+4o3gZSETyqzbY6+tqaV/9MukWUdAhFLq9P
 KDKeHOe/7OnqoXdQhCXA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 December 2013, Sergei Ianovich wrote:
> 
> Except for defconfig, this is a completely new series. The first
> eight patches fix outstanding issues with device tree support
> in PXA. The 9th boots ICP DAS LP-8x4x.

Awesome! That was very quick. The main comment I have is for the
dmaengine support, you will need to rebase on Daniel's patches for
that. I also found few minor details.

	Arnd
