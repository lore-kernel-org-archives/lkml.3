Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaIHTBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:01:05 -0400
Received: from [8.25.196.27] ([8.25.196.27]:46052 "EHLO ham-cannon.twitter.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753977AbaIHTBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:01:03 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 15:01:03 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 2452415620.twitter.com A6B3912845F
X-DomainKeys: Sendmail DomainKeys Filter v1.0.2 2452415620.twitter.com A6B3912845F
Date: Mon, 8 Sep 2014 11:50:40 -0700
From: Matt Mullins <mmullins@twopensource.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Dan Aloni <dan@kernelim.com>
Subject: Re: [PATCH v2] nfs: fix kernel warning when removing proc entry
Message-ID: <20140908185039.GA1616@whiteoak.sf.office.twttr.net>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	Trond Myklebust <trond.myklebust@primarydata.com>,
	Dan Aloni <dan@kernelim.com>
References: <1408217806-25877-1-git-send-email-xiyou.wangcong@gmail.com>
 <87ppfvrdux.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppfvrdux.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 09:20:38PM -0700, Eric W. Biederman wrote:
> I have applied this patch and will push it to Linus after it has a
> little bit to sit in linux-next.

I also fairly reliably hit this warning with trinity, and with Cong's
patch, it seems to be gone.

If it helps get it pushed toward Linus:
Tested-by: Matt Mullins <mmullins@twopensource.com>
