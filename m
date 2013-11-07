Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3KGRM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:12:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3KGRMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:12:24 -0500
Message-ID: <527BC98B.5060701@redhat.com>
Date: Thu, 07 Nov 2013 12:10:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, mgorman@suse.de, hughd@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
References: <20131107070451.GA10645@bbox>
In-Reply-To: <20131107070451.GA10645@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 02:04 AM, Minchan Kim wrote:

> I'm guilty and I have been busy by other stuff. Sorry for that.
> Fortunately, I discussed this issue with Hugh in this Linuxcon for a
> long time(Thanks Hugh!) he felt zram's block device abstraction is
> better design rather than frontswap backend stuff although it's a question
> where we put zsmalloc. I will CC Hugh because many of things is related
> to swap subsystem and his opinion is really important.
> And I discussed it with Rik and he feel positive about zram.

To clarify that, I agree with Minchan that there are certain
workloads where zram is probably more appropriate than zswap.

For most of the workloads that I am interested in, zswap will
be more interesting, but zram seems to have its own niche, and
I certainly do not want to hold back the embedded folks...

