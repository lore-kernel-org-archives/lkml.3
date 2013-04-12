Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3DLBFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:05:00 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:60170 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3DLBE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
References: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
Date: Thu, 11 Apr 2013 18:04:57 -0700
X-Google-Sender-Auth: 9Vvfin45maQj8VnJiK2FGrzameo
Message-ID: <CAA9_cmf7vdzfnE=mqhUkF+6TxOLQ3cDMpror0-v4frAZzcJNoQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] ioatdma: Intel S1200 support patches
From: Dan Williams <djbw@fb.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 4:44 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> These are the updated patches from first submission series and rebased against
> vinod's slave-dma git tree for-linus branch.
>
> Patches 1 & 4 have been updated after discussion with Dan.

Patches 1-4 acked.

> Patch 5 was acked by
> Dan but requires additional review by Dan. I had to make additional modification
> to get raid6test working.

Yeah, we need to find a way to support this without allowing silent
channel switching on engines that can't support it.

--
Dan
