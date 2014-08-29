Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaH2IIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:08:16 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:60070 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaH2IIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:08:11 -0400
Date: Fri, 29 Aug 2014 09:08:08 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, decui@microsoft.com
Subject: Re: [PATCH 0/2] Drivers: hv: vmbus: Miscellaneous cleanup
Message-ID: <20140829080807.GB842@sucs.org>
References: <1409275773-28472-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409275773-28472-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 06:29:33PM -0700, K. Y. Srinivasan wrote:
> Cleanup hv_post_message() to minimize failures. Also disable preemption
> when sampling CPU ID when preemption is otherwise possible.
> 
> K. Y. Srinivasan (2):
>   Drivers: hv: vmbus: Cleanup hv_post_message()
>   Drivers: hv: vmbus: Properly protect calls to smp_processor_id()

These patches (on top of the "Drivers: hv: vmbus: Eliminate calls to
BUG_ON()" series) resolve an issue I was seeing  where the Hyper-V
framebuffer driver would fail when booting a 3.17.0-rc2 verification
kernel on a UP system.

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

-- 
Sitsofe | http://sucs.org/~sits/
