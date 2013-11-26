Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3KZDYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:24:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:14752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3KZDYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:24:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,771,1378882800"; 
   d="scan'208";a="414815582"
Subject: Re: [PATCH V2] n_gsm: race between ld close and gsmtty open
From: channing <chao.bi@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
In-Reply-To: <20131126031629.GA16763@kroah.com>
References: <1385435645.7741.28.camel@bichao>
	 <20131126025432.GA3379@kroah.com> <1385436914.7741.40.camel@bichao>
	 <20131126031629.GA16763@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Nov 2013 11:53:58 +0800
Message-ID: <1385438038.7741.47.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 19:16 -0800, Greg KH wrote:
> > > 
> > > What is different from the previous version?  That information needs to
> > > be somewhere, otherwise I'm just going to guess and say this is the same
> > > as your last one, which was incorrect.
> > The difference with previous one is to use a mutex instead of spin lock
> > to avoid race, purpose is to avoid sleep in atomic context. I've also
> > updated commit a little as above.
> 
> Then be explicit as to what has changed somewhere.  We deal with
> thousands of patches a week, we can not know that you changed one
> sentance in a patch description of a few hundred lines long to know you
> made a change to the patch itself as well...
OK, in next patch set, I'll highlight difference with previous patch
set.

