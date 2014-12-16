Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaLPXuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:50:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLPXua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:50:30 -0500
Date: Tue, 16 Dec 2014 15:50:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Tim Hartrick <tim@edgecast.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3] mm: prevent endless growth of anon_vma hierarchy
Message-Id: <20141216155028.6a500d7a79eab815dbeb950e@linux-foundation.org>
In-Reply-To: <20141216104218.GB22920@dhcp22.suse.cz>
References: <20141126191145.3089.90947.stgit@zurg>
	<20141216104218.GB22920@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014 11:42:18 +0100 Michal Hocko <mhocko@suse.cz> wrote:

> What happened to this patch? I do not see it merged for 3.19 and
> nor in the current mmotm tree (2014-12-15-17-05)
> 

Awaiting v4.  See Konstantin's reply to Rik's review comments.

Konstantin, please ensure that the questions which Rik asked are
answered (via code comments and changelogging) in the next version?
Because other future readers will have the same questions.


