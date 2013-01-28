Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3A1P4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:56:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3A1Pz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:55:58 -0500
Date: Mon, 28 Jan 2013 10:55:51 -0500
From: David Teigland <teigland@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 09/14] dlm: use idr_for_each_entry() in
 recover_idr_clear() error path
Message-ID: <20130128155551.GB16789@redhat.com>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359163872-1949-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 05:31:07PM -0800, Tejun Heo wrote:
> Convert recover_idr_clear() to use idr_for_each_entry() instead of
> idr_for_each().  It's somewhat less efficient this way but it
> shouldn't matter in an error path.  This is to help with deprecation
> of idr_remove_all().
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Christine Caulfield <ccaulfie@redhat.com>
> Cc: David Teigland <teigland@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
> This patch depends on an earlier idr patch and I think it would be
> best to route these together through -mm.  Christine, David, can you
> please ack this?

Ack

