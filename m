Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3KMGY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:24:56 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44185 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3KMGYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:24:49 -0500
Message-ID: <52831B2C.7090905@vflare.org>
Date: Tue, 12 Nov 2013 22:24:44 -0800
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, mgorman@suse.de, riel@redhat.com,
        hughd@google.com, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Luigi Semenzato <semenzato@google.com>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
References: <20131107070451.GA10645@bbox> <20131112154137.GA3330@gmail.com> <20131113024252.GA1023@kroah.com>
In-Reply-To: <20131113024252.GA1023@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13, 6:42 PM, Greg KH wrote:
> On Wed, Nov 13, 2013 at 12:41:38AM +0900, Minchan Kim wrote:
>> We spent much time with preventing zram enhance since it have been in staging
>> and Greg never want to improve without promotion.
>
> It's not "improve", it's "Greg does not want you adding new features and
> functionality while the code is in staging."  I want you to spend your
> time on getting it out of staging first.
>
> Now if something needs to be done based on review and comments to the
> code, then that's fine to do and I'll accept that, but I've been seeing
> new functionality be added to the code, which I will not accept because
> it seems that you all have given up on getting it merged, which isn't
> ok.
>

It's not that people have given up on getting it merged but every time 
patches are posted, there is really no response from maintainers perhaps 
due to their lack of interest in embedded, or perhaps they believe 
embedded folks are making a wrong choice by using zram. Either way, a 
final word, instead of just silence would be more helpful.

Thanks,
Nitin

