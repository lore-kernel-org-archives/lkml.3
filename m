Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaLHJ4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:56:43 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50154 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaLHJ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:56:41 -0500
Date: Mon, 8 Dec 2014 01:56:37 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation of current lglocks implementation
Message-ID: <20141208095637.GB2821@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Nicholas Mc Guire <der.herr@hofr.at>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20141208083326.GA29895@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208083326.GA29895@opentech.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas,

On Mon, Dec 08, 2014 at 09:33:26AM +0100, Nicholas Mc Guire wrote:
> 
> Documentation of current lglocks implementation
> 
> local/global locks are currently not documented anywhere other
> than in an somewhat out-of-date LWN article - this is an attempt
[...]
> +Implementation:
> +---------------
> +
> +The initial lglock implementation from Nick Piggin used some complex
> +macros to generate the lglock/brlock in lglock.h - they were later
> +turned into a set of functions by Andi Kleen [7]. The change to functions
> +was motivated by the presence of multiple lock users and also by them
> +being easier to maintain than the generating macros. This change to
> +functions is also the basis to eliminated the restriction of not
> +being initializeable in kernel modules (the remaining problem is that
         ^^^^^^^^^^^^^^
		 initializable

> +locks are not explicitly initialized - see lockdep-design.txt)
> +
> +Declaration and initialization:
> +-------------------------------
> +
> +  #include <linux/lglock.h>
[...]

-- 
- Jeremiah Mahler
