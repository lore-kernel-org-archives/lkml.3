Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3C1Gbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:31:37 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:52459 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3C1Gbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:31:36 -0400
Date: Wed, 27 Mar 2013 23:31:29 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] workqueue: fix race condition in unbound workqueue
 free path
Message-ID: <20130328063129.GC14088@htj.dyndns.org>
References: <20130328062947.GA14088@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328062947.GA14088@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, forgot something.

Both patches are against wq/for-3.10 and fix problems introduced in
this devel cycle, so no need to be alarmed.

Thanks.

-- 
tejun
