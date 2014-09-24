Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIXOkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:40:24 -0400
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:53245 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbaIXOkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:40:23 -0400
Date: Wed, 24 Sep 2014 09:40:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mark Rutland <mark.rutland@arm.com>
cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] Docs: this_cpu_ops: remove redundant add forms
In-Reply-To: <1411566583-22220-1-git-send-email-mark.rutland@arm.com>
Message-ID: <alpine.DEB.2.11.1409240939520.6426@gentwo.org>
References: <1411566583-22220-1-git-send-email-mark.rutland@arm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Mark Rutland wrote:

> I spotted the below while trying to figure out how to use this_cpu ops,
> and it left me confused for a short while.
>
> I guess that this is a refactoring fallout rather than there being a
> special this_cpu_add variant?

Thanks for fixing it.

Acked-by: Christoph Lameter <cl@linux.com>
