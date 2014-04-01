Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaDAVhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:37:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37069 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaDAVhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:37:31 -0400
Message-ID: <533B313E.5000403@zytor.com>
Date: Tue, 01 Apr 2014 14:35:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Volatile Ranges (v12) & LSF-MM discussion fodder
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <20140401212102.GM4407@cmpxchg.org>
In-Reply-To: <20140401212102.GM4407@cmpxchg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 02:21 PM, Johannes Weiner wrote:
> 
> Either way, optimistic volatile pointers are nowhere near as
> transparent to the application as the above description suggests,
> which makes this usecase not very interesting, IMO.
> 

... however, I think you're still derating the value way too much.  The
case of user space doing elastic memory management is more and more
common, and for a lot of those applications it is perfectly reasonable
to either not do system calls or to have to devolatilize first.

	-hpa

