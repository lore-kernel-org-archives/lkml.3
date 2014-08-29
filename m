Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaH2I0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:26:44 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50718 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaH2I0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:26:42 -0400
Date: Fri, 29 Aug 2014 09:26:36 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, decui@microsoft.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Drivers: hv: vmbus: Cleanup hv_post_message()
Message-ID: <20140829082636.GB11445@sucs.org>
References: <1409275773-28472-1-git-send-email-kys@microsoft.com>
 <1409275793-28511-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409275793-28511-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 06:29:52PM -0700, K. Y. Srinivasan wrote:
> Minimize failures in this function by pre-allocating the buffer
> for posting messages. The hypercall for posting the message can fail
> for a number of reasons:
> 
<snip>
> 
> Cc: <stable@vger.kernel.org>

Is this patch useful for all longterm (2.6.32.63, 3.2.62, 3.4.103,
3.10.53, 3.12.27, 3.14.17) in addition to stable (3.16.1) kernels? I've
noticed some other LKML messages sometimes have the following (but there
doesn't seem to be a standard):

Cc: stable@vger.kernel.org # 3.4+

-- 
Sitsofe | http://sucs.org/~sits/
