Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbaFRGMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:12:40 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51438 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbaFRGMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:12:36 -0400
Date: Wed, 18 Jun 2014 09:12:30 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        mgorman@suse.de, yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, laijs@cn.fujitsu.com, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] Move two pinned pages to non-movable node in kvm.
Message-ID: <20140618061230.GA10948@minantech.com>
References: <1403070600-6083-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403070600-6083-1-git-send-email-tangchen@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:50:00PM +0800, Tang Chen wrote:
> [Questions]
> And by the way, would you guys please answer the following questions for me ?
> 
> 1. What's the ept identity pagetable for ?  Only one page is enough ?
> 
> 2. Is the ept identity pagetable only used in realmode ?
>    Can we free it once the guest is up (vcpu in protect mode)?
> 
> 3. Now, ept identity pagetable is allocated in qemu userspace.
>    Can we allocate it in kernel space ?
What would be the benefit?

> 
> 4. If I want to migrate these two pages, what do you think is the best way ?
> 
I answered most of those here: http://www.mail-archive.com/kvm@vger.kernel.org/msg103718.html

--
			Gleb.
