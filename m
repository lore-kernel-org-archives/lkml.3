Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaJVQQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:16:45 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:49324 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbaJVQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:16:43 -0400
Date: Wed, 22 Oct 2014 18:16:38 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Eunbong Song <eunb.song@samsung.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: add arch_trigger_all_cpu_backtrace() function
Message-ID: <20141022161637.GA12502@linux-mips.org>
References: <1669712409.167661413959996217.JavaMail.weblogic@epmlwas02b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669712409.167661413959996217.JavaMail.weblogic@epmlwas02b>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 06:39:56AM +0000, Eunbong Song wrote:

Applying - but:

> +	if(regs)
         ^^^

There should be a blank between if and opening parenthesis.

  Ralf
