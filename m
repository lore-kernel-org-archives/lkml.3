Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaIMRG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 13:06:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaIMRG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 13:06:26 -0400
Message-ID: <54147991.9080502@infradead.org>
Date: Sat, 13 Sep 2014 10:06:25 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
CC: linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: support glibc versions without htole macros
References: <1410373861-5968-1-git-send-email-pefoley2@pefoley.com>
In-Reply-To: <1410373861-5968-1-git-send-email-pefoley2@pefoley.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 11:31, Peter Foley wrote:
> glibc 2.9 introduced the htole<16/32/64> macros, add them to
> tools/include to support older versions of glibc.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>

Applied. Thanks.

> ---
>  Documentation/arm/SH-Mobile/Makefile |  2 +-
>  Documentation/arm/SH-Mobile/vrl4.c   |  1 +
>  Documentation/mic/mpssd/Makefile     |  2 +-
>  Documentation/mic/mpssd/mpssd.c      |  1 +
>  tools/include/tools/endian.h         | 32 ++++++++++++++++++++++++++++++++
>  5 files changed, 36 insertions(+), 2 deletions(-)
>  create mode 100644 tools/include/tools/endian.h


-- 
~Randy
