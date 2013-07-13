Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078Ab3GMEkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 00:40:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44348 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3GMEkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 00:40:04 -0400
Message-ID: <51E0DA05.4090107@zytor.com>
Date: Fri, 12 Jul 2013 21:39:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC 4/4] Sparse initialization of struct page array.
References: <1373594635-131067-1-git-send-email-holt@sgi.com> <1373594635-131067-5-git-send-email-holt@sgi.com> <CAE9FiQW1s2UwCY6OjzD3+2wG8SjCr1QyCpajhZbk_XhmnFQW4Q@mail.gmail.com>
In-Reply-To: <CAE9FiQW1s2UwCY6OjzD3+2wG8SjCr1QyCpajhZbk_XhmnFQW4Q@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 09:19 PM, Yinghai Lu wrote:
>>         PG_reserved,
>> +       PG_uninitialized2mib,   /* Is this the right spot? ntz - Yes - rmh */
>>         PG_private,             /* If pagecache, has fs-private data */

The comment here is WTF...

	-hpa


