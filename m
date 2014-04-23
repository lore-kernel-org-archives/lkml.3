Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbaDWRB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:01:57 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51644 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaDWRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:01:53 -0400
Date: Wed, 23 Apr 2014 13:01:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Message-ID: <20140423170141.GJ4781@htj.dyndns.org>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415141826.GB17018@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:18:26AM -0400, Vivek Goyal wrote:
> Ok, that's fine. Let us just document the knobs well so that people can
> find which knob is giving what information and make cfq names better at
> the expense of inconsistency of names with throttling layer.

I've been thinking about it more.  Why do we even have separate stats
for common things like bytes transferred?  It doesn't serve any
purpose to do double accounting and reporting on everything, does it?
Shouldn't we just have single set of common stats for things like
requests / bytes serviced?

Thanks.

-- 
tejun
