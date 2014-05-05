Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaEEJQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:16:31 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:62315 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbaEEJQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:16:30 -0400
MIME-Version: 1.0
In-Reply-To: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
References: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
Date: Mon, 5 May 2014 17:16:29 +0800
Message-ID: <CACVXFVMcp+hshMEbXSHVS9QKn5FrE-1Fr_GvoVPAc0aRAwcLiw@mail.gmail.com>
Subject: Re: [PATCH 0/3] percpu_ida: support to export allocation/free information
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@lst.de>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Nick Swenson <nks@daterainc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 29, 2014 at 10:53 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi,
>
> These patches support to export percpu_ida allocation/free information
> via sysfs, so that percpu_ida performance can be monitored, and
> at least two use cases:
>
> - some parameters(such as percpu_max_size) from its users are very
> sensitive to performance
>
> - the data is helpful for verifying patches which try to improve
> percpu_ida

Gentle ping, :-)


Thanks,
-- 
Ming Lei
