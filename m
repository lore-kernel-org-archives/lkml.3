Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaGIWT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:19:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbaGIWTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:19:23 -0400
Date: Thu, 10 Jul 2014 00:18:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org
Subject: Re: perf: Add support for full Intel event lists v7
Message-ID: <20140709221843.GA20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:15:55PM -0700, Andi Kleen wrote:
> Should be ready for merge now. Please consider.
> 
> [v2: Review feedback addressed and some minor improvements]
> [v3: More review feedback addressed and handle test failures better.
> Ported to latest tip/core.]
> [v4: Addressed Namhyung's feedback]
> [v5: Rebase to latest tree. Minor description update.]
> [v6: Rebase. Add acked by from Namhyung and address feedback. Some minor
> fixes. Should be good to go now I hope. The period patch was dropped,
> as that is already handled. I added an extra patch for a --quiet argument
> for perf list]
> [v7: Just rebase to latest tip/core. Should be ready to merge.]

please remove 'vX' suffixes from patch subjects

jirka
