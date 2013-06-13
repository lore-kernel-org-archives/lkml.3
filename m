Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab3FMDtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:49:04 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:43135 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab3FMDtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:49:03 -0400
Date: Wed, 12 Jun 2013 20:48:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Tejun Heo <theo@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11 1/2] percpu-refcount: cosmetic updates
Message-ID: <20130613034857.GB9451@mtj.dyndns.org>
References: <20130612204532.GB15092@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612204532.GB15092@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:45:32PM -0700, Tejun Heo wrote:
> From 49d1e1a6561f1e4b190695f36d2594c7c04b8e76 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 12 Jun 2013 13:37:42 -0700
> 
> * s/percpu_ref_release/percpu_ref_func_t/ as it's customary to have _t
>   postfix for types and the type is gonna be used for a different type
>   of callback too.
> 
> * Add @ARG to function comments.
> 
> * Drop unnecessary and unaligned indentation from percpu_ref_init()
>   function comment.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied to percpu/for-3.11.  Thanks.

-- 
tejun
