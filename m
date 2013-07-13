Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab3GMFbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 01:31:18 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51363 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3GMFbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 01:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <51E0DA05.4090107@zytor.com>
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
	<1373594635-131067-5-git-send-email-holt@sgi.com>
	<CAE9FiQW1s2UwCY6OjzD3+2wG8SjCr1QyCpajhZbk_XhmnFQW4Q@mail.gmail.com>
	<51E0DA05.4090107@zytor.com>
Date: Fri, 12 Jul 2013 22:31:16 -0700
X-Google-Sender-Auth: usIi7qxQjb90onbFx8jYv68T4F0
Message-ID: <CAE9FiQWFdQC_YZ1S-oyJbaWzpDHW4i_XT6SnWuwsoWzcL8_NLA@mail.gmail.com>
Subject: Re: [RFC 4/4] Sparse initialization of struct page array.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 9:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/12/2013 09:19 PM, Yinghai Lu wrote:
>>>         PG_reserved,
>>> +       PG_uninitialized2mib,   /* Is this the right spot? ntz - Yes - rmh */
>>>         PG_private,             /* If pagecache, has fs-private data */
>
> The comment here is WTF...

ntz: Nate Zimmer?
rmh: Robin Holt?
