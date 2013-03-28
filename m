Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3C1KkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:40:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab3C1KkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:40:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: Generic syscall ABI support
Date: Thu, 28 Mar 2013 10:40:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1364440182.2289.45.camel@leyfoon-vm> <201303280744.27477.arnd@arndb.de> <1364459522.2308.6.camel@leyfoon-vm>
In-Reply-To: <1364459522.2308.6.camel@leyfoon-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281040.04463.arnd@arndb.de>
X-Provags-ID: V02:K0:ljvYg5EVhx7ctSkyVUBQ5galM+/OiEccm9ISNLuN4Z/
 Ml/bolmI0jFkQ1Qq9OIXYbQ4TF5beS+24HehlxUyFcyV2ihnH3
 8U91HHaBm32SO5L9jlf3QorzR+dN9xT3rQCQN3LiMbOCASc9r7
 MKG4ro5tKwHdk6amc2XS0Jn9xoLS8Oqw1Mtnkdn8encSw0SDwQ
 FUi4Zj5DoqwmwsYkvahB9GG/cDj9d7meGBqK1IzX3Yl/SHll+v
 yschFuE7tl8ygtAM/t1zWHLajJOZAHUtT+HDC+YIdTSqXViAiO
 LZI7pxaqJsYocCZFE8idmToYzDHT+FRtHg52K6BCWNttpGWRZz
 pFhyPSjOMMyb6FFREaL8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, Ley Foon Tan wrote:
> We will working on generic ABI for kernel and Glibc. This might take
> some times.

Ok. Don't let that hold you up from submitting the kernel patches
for review though.

	Arnd
