Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaESLV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbaESLV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:21:57 -0400
Date: Mon, 19 May 2014 13:21:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/6] Revert "perf: Disable PERF_RECORD_MMAP2 support"
Message-ID: <20140519112116.GC5027@krava.brq.redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399999697-65875-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:48:13PM -0400, Don Zickus wrote:
> This reverts commit 3090ffb5a2515990182f3f55b0688a7817325488.
> 
> Conflicts:
> 	tools/perf/util/event.c

also besides the missing Signed-off ;-) could I have more
info in changelog, like we revert this now etc..?

thanks,
jirka
