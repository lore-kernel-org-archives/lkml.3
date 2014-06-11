Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbaFKRKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:10:09 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:52395 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbaFKRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:10:07 -0400
Date: Wed, 11 Jun 2014 19:10:00 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Eunbong Song <eunb.song@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: mips: math-emu: Fix compilation error ieee754.c
Message-ID: <20140611171000.GD26335@linux-mips.org>
References: <2463243.264261402478691777.JavaMail.weblogic@epml26>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2463243.264261402478691777.JavaMail.weblogic@epml26>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 09:24:51AM +0000, Eunbong Song wrote:

> ieee754dp has bitfield member in struct without name. And this
> cause compilation error. This patch removes struct in ieee754dp
> declaration. So compilation error is fixed.
> Signed-off-by: Eunbong Song <eunb.song@samsung.com>

What gcc version are you using?

  Ralf
