Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaH2H31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:29:27 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45951 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaH2H3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:29:25 -0400
Date: Fri, 29 Aug 2014 08:29:18 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, decui@microsoft.com
Subject: Re: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to BUG_ON()
Message-ID: <20140829072918.GA842@sucs.org>
References: <1409181905-23254-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409181905-23254-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 04:25:05PM -0700, K. Y. Srinivasan wrote:
> Cleanup the channel management code and eliminate calls to BUG_ON().
> Also fix an error propagation bug in vmbus_open().
> 
> In this version of the patch-set, I have addressed comments from
> Dan Carpenter.
> 
> K. Y. Srinivasan (5):
>   Drivers: hv: vmbus: Cleanup vmbus_post_msg()
>   Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
>   Drivers: hv: vmbus: Cleanup vmbus_close_internal()
>   Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
>   Drivers: hv: vmbus: Fix a bug in vmbus_open()

This patch set resolves a number of BUG_ON crashes I was hitting on
Hyper-V while booting a kernel with verification options on. With these
I can complete a 3.17.0-rc2 boot on an SMP setup although patches from
"Drivers: hv: vmbus: Miscellaneous cleanup" are needed to resolve other
non-crash issues.

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

-- 
Sitsofe | http://sucs.org/~sits/
