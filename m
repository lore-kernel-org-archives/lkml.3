Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3JLAwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:52:40 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46390 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3JLAwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:52:38 -0400
Date: Sat, 12 Oct 2013 08:52:27 +0800
From: Shaohua Li <shli@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [patch 1/4] percpu_ida: make percpu_ida percpu size/batch
 configurable
Message-ID: <20131012005227.GB17666@kernel.org>
References: <20131011071802.148101321@kernel.org>
 <20131011072300.494245221@kernel.org>
 <20131011203152.GH28572@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011203152.GH28572@kmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 01:31:52PM -0700, Kent Overstreet wrote:
> On Fri, Oct 11, 2013 at 03:18:03PM +0800, Shaohua Li wrote:
> > Make percpu_ida percpu size/batch configurable. The block-mq-tag will use it.
> 
> Can you explain the justification for this? Performance...?

The performance using percpu_ida for tag management? Please see the patch 4
thread.  If you ask the justification of making the size/batch configurable,
the answer is we might have no enough tags, and default cache size/batch is too
aggressive.

Thanks,
Shaohua
