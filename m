Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbaGWPM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:12:27 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:49640 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbaGWPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:12:24 -0400
Date: Wed, 23 Jul 2014 11:12:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lizefan@huawei.com
Subject: Re: WARNING: at kernel/cpuset.c:1139
Message-ID: <20140723151220.GD7103@htj.dyndns.org>
References: <53CF22F5.6000206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF22F5.6000206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:50:29AM +0800, Mike Qiu wrote:
> commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when config
> changes") introduce the below warning in my server.
> 
> [   35.652137] ------------[ cut here ]------------
> [   35.652141] WARNING: at kernel/cpuset.c:1139

Hah, can you reproduce it?  If so, can you detail how?

Thanks.

-- 
tejun
