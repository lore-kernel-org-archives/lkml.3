Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3HWHa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:30:59 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54722 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3HWHa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:30:58 -0400
Date: Fri, 23 Aug 2013 09:30:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Liu Ping Fan <kernelfans@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kevin Hao <haokexin@gmail.com>
Subject: Re: [PATCH] x86: ioapic needs check attr when programmed more than
 once
Message-ID: <20130823073052.GA25533@gmail.com>
References: <1377161197-3175-1-git-send-email-pingfank@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377161197-3175-1-git-send-email-pingfank@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Liu Ping Fan <kernelfans@gmail.com> wrote:

> When programming ioapic pinX more than once, current code
> does not check whether the later attr (trigger&polarity) is the
> same as the former or not. This causes a broken semantic.
> 
> Fix it by reporting -EBUSY, when attr is different.

Was this observed in real life somehow, and if yes, what is 
the before/after behavior?

Thanks,

	Ingo
