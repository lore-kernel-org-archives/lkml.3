Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3JMT5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 15:57:40 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:64974 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab3JMT5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 15:57:38 -0400
Date: Sun, 13 Oct 2013 15:57:35 -0400
From: Tejun Heo <tj@kernel.org>
To: xiangliang yu <yxlraid@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
Message-ID: <20131013195735.GD18075@htj.dyndns.org>
References: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
 <20130928114950.GA2620@htj.dyndns.org>
 <CAP0P+NUvaLfXkOUGm8NX19AHvTHmU=Ya0NdFvyJc2gFjN-Cy0A@mail.gmail.com>
 <20130928131059.GA3945@htj.dyndns.org>
 <CAP0P+NXD7pdXQwBUZJdUwyCc=o_5iTzmKJ6FdN6LrqcgX3yK2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP0P+NXD7pdXQwBUZJdUwyCc=o_5iTzmKJ6FdN6LrqcgX3yK2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Oct 12, 2013 at 02:56:34PM +0800, xiangliang yu wrote:
> > So it can't find the disk if FBS stays enabled?  Can you please attach
> > the boot log before & after?
> 
> Below is boot log:

And it works after the patch, right?  Can you please update the patch
description so that it includes what was failing before and how it was
tested?

Thanks.

-- 
tejun
