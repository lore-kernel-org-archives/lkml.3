Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaG2DCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 23:02:08 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33304 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaG2DCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 23:02:03 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 29 Jul 2014 12:01:58 +0900
From: Minchan Kim <minchan@kernel.org>
To: Yogesh Gaur <yogeshgaur.83@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org
Subject: Re: Patch: zram add compressionratio in sysfs interface
Message-ID: <20140729030158.GB22707@bbox>
References: <CAG6enPwuD2_6U=iELn9C7gMzxre0V-VYmxP14R-qW3sMNddvCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG6enPwuD2_6U=iELn9C7gMzxre0V-VYmxP14R-qW3sMNddvCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 23, 2014 at 02:58:00PM +0530, Yogesh Gaur wrote:
> Hello All,
> 
> Please find attached patch which adds new entry in existing zram device
> sysfs interface, this interface shows compression ratio for asked zram
> device.
> Sysfs interface for 'orig_data_size' and 'mem_used_total' already present,
> 'compression_ratio' would be orig_data_size divided by mem_used_total.
> 
> Please check patch.

Pz, do it in userspace.

> 
> --
> Regards,
> Yogesh Gaur.



-- 
Kind regards,
Minchan Kim
