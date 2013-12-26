Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3LZPfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:35:16 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:45213 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3LZPfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:35:15 -0500
Date: Thu, 26 Dec 2013 07:35:09 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t in struct timex
Message-ID: <20131226153509.GA23355@gmail.com>
References: <20131225002458.GA363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131225002458.GA363@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 04:24:58PM -0800, H.J. Lu wrote:
> X32 adjtimex system call is the same as x86-64 adjtimex system call,
> which uses 64-bit integer for long in struct timex. But x32 long is
> 32 bit.  This patch replaces long in struct timex with __kernel_long_t.
> 

Here is the updated patch which uses __kernel_long_t only if
__BITS_PER_LONG == 64.

H.J.
