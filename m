Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3AVIXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:23:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3AVIXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:23:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 29/76] ARC: Boot #1: low-level, setup_arch(), /proc/cpuinfo, mem init
Date: Tue, 22 Jan 2013 08:23:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <201301181445.39050.arnd@arndb.de> <50FE4497.3050306@synopsys.com>
In-Reply-To: <50FE4497.3050306@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301220823.44872.arnd@arndb.de>
X-Provags-ID: V02:K0:jLAan0EygY25OHXokpUdDHGrllW6EenZI782GrBnJvd
 SqgrJ0XWu03JQ7s3bL6JwtaW1foA8RxeIg5XbRAw/PKx7E3NOL
 bqxQM3tEEPoTgAyAbRDmtNfBVUPogBPqvCUdL/sCREmXyqunfd
 x1zKAKR7zJYoI7U5X6Pp4NpKZ4dDvpBPfSJv5j6Iy28N/fC9gh
 OGkJ+odHmcEen+cwG2yuuUm2a6aWtoBEMZqJXc4pZImOfzKMMj
 sbFtXT3hnNi63Q+cK2rK+jnm9FjZjRJNm+B2j4RM44CgoGnLYO
 QzmVCzIPKhBJ+AYbhT+ah2aK1Tpq8jQkQ5hcP4EWfuHKARB7J+
 RYp5D9pYvvW/ZN8I0sN4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Vineet Gupta wrote:
> How does the following look like. This is RFC only and I'll squash it into Boot #1
> patch.
> 
> From: Vineet Gupta <vgupta@synopsys.com>
> Date: Tue, 22 Jan 2013 13:03:50 +0530
> Subject: [PATCH] RFC: Convert ARC port from bootmem to memblock
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---

Looks good to me, although I might be missing some details.

Given that everything still seems to work for you,

Acked-by: Arnd Bergmann <arnd@arndb.de>

on the combined patch.
