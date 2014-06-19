Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaFSPBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:01:09 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58140 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbaFSPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:01:08 -0400
Date: Thu, 19 Jun 2014 11:01:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: percpu: micro-optimize round-to-even
Message-ID: <20140619150104.GH26904@htj.dyndns.org>
References: <1403172149-25353-1-git-send-email-linux@rasmusvillemoes.dk>
 <20140619132536.GF11042@htj.dyndns.org>
 <alpine.DEB.2.11.1406190925430.2785@gentwo.org>
 <20140619143458.GF26904@htj.dyndns.org>
 <alpine.DEB.2.11.1406190957030.2785@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406190957030.2785@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:59:18AM -0500, Christoph Lameter wrote:
> On Thu, 19 Jun 2014, Tejun Heo wrote:
> 
> > Indeed, a patch?
> 
> Subject: percpu: Use ALIGN macro instead of hand coding alignment calculation
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.17.  Thanks.

-- 
tejun
