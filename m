Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3DLNKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:10:48 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:30016 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab3DLNKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:10:47 -0400
Message-ID: <516807CB.6040208@parallels.com>
Date: Fri, 12 Apr 2013 17:10:35 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] pagemap: Introduce the /proc/PID/pagemap2 file
References: <51669E5F.4000801@parallels.com> <51669EA5.20209@parallels.com> <20130411141944.dc17b3b1c78132eedec06aa6@linux-foundation.org>
In-Reply-To: <20130411141944.dc17b3b1c78132eedec06aa6@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 01:19 AM, Andrew Morton wrote:
> On Thu, 11 Apr 2013 15:29:41 +0400 Pavel Emelyanov <xemul@parallels.com> wrote:
> 
>> This file is the same as the pagemap one, but shows entries with bits
>> 55-60 being zero (reserved for future use). Next patch will occupy one
>> of them.
> 
> I'm not understanding the motivation for this.  What does the current
> /proc/pid/pagemap have in those bit positions?

A constant PAGE_SHIFT value.

> 
> .
> 

Thanks,
Pavel
