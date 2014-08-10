Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaHJR1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 13:27:38 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:45600 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaHJR1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 13:27:37 -0400
MIME-Version: 1.0
X-Originating-IP: [80.196.35.44]
In-Reply-To: <1406365643-27020-2-git-send-email-m@bjorling.me>
References: <1406365643-27020-1-git-send-email-m@bjorling.me>
	<1406365643-27020-2-git-send-email-m@bjorling.me>
Date: Sun, 10 Aug 2014 19:27:36 +0200
Message-ID: <CAOu_J6mW-2e2Jgm+khodLPah_-RZrD599SmSH+Mszd0AjterrQ@mail.gmail.com>
Subject: Re: [PATCH v11] NVMe: Convert to blk-mq
From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
To: Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Cc: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 11:07 AM, Matias Bjørling <m@bjorling.me> wrote:
> This converts the NVMe driver to a blk-mq request-based driver.
>

Willy, do you need me to make any changes to the conversion? Can you
pick it up for 3.17?

Thanks,
Matias
