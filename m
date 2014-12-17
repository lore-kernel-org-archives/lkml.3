Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaLQJEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:04:33 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41803 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaLQJE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:04:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141216155028.6a500d7a79eab815dbeb950e@linux-foundation.org>
References: <20141126191145.3089.90947.stgit@zurg>
	<20141216104218.GB22920@dhcp22.suse.cz>
	<20141216155028.6a500d7a79eab815dbeb950e@linux-foundation.org>
Date: Wed, 17 Dec 2014 13:04:25 +0400
Message-ID: <CALYGNiNSA1faTB_9Ngdrsv8xS7einysdMmmVeX=T-aX_RJLobg@mail.gmail.com>
Subject: Re: [PATCH v3] mm: prevent endless growth of anon_vma hierarchy
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Tim Hartrick <tim@edgecast.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 2:50 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 16 Dec 2014 11:42:18 +0100 Michal Hocko <mhocko@suse.cz> wrote:
>
>> What happened to this patch? I do not see it merged for 3.19 and
>> nor in the current mmotm tree (2014-12-15-17-05)
>>
>
> Awaiting v4.  See Konstantin's reply to Rik's review comments.
>
> Konstantin, please ensure that the questions which Rik asked are
> answered (via code comments and changelogging) in the next version?
> Because other future readers will have the same questions.
>

Done.

Thanks for reminding.
