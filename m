Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaDOSUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:20:45 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:62944 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaDOSUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:20:41 -0400
Date: Tue, 15 Apr 2014 14:20:38 -0400
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: block: Replace __this_cpu_ptr with raw_cpu_ptr
Message-ID: <20140415182038.GG30990@htj.dyndns.org>
References: <alpine.DEB.2.10.1404151236390.27497@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404151236390.27497@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:38:05PM -0500, Christoph Lameter wrote:
> __this_cpu_ptr is being phased out use raw_cpu_ptr instead which was
> introduced in 3.15-rc1.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
