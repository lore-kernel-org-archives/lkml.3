Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3LJH0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:26:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:15663 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab3LJH0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:26:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,864,1378882800"; 
   d="scan'208";a="441517363"
Date: Tue, 10 Dec 2013 15:26:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devtmpfs: Calling delete_path() only when necessary
Message-ID: <20131210072633.GB27859@localhost>
References: <1384589723.7840.1.camel@phoenix>
 <1386125959.1974.309@driftwood>
 <CAFRkauAzR=BqJGrMzN0i-tvi5mcQvyB9Kihk0YvxMpk=SWGvFA@mail.gmail.com>
 <20131209064654.GA20485@kroah.com>
 <CAFRkauCQdOyWbck+WtmNxtnenKyPAFNcqqUgcGSb1kAqj56sYA@mail.gmail.com>
 <20131209090530.GA4586@kroah.com>
 <CAFRkauCX+dLNiuoy7bPWO_ZE06OhorqYkkGh5pc8L3XyqNA-rg@mail.gmail.com>
 <CAFRkauBwUoE9109Oq9cgG71uOw5Uc+zZyDWsuCf47oLk-a2ngQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRkauBwUoE9109Oq9cgG71uOw5Uc+zZyDWsuCf47oLk-a2ngQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Fengguang
> Can you help to add this patch to your test systems?
> It's a one-line change, you can find the patch at
> https://patchwork.kernel.org/patch/3192361/

Hi Axel,

Do you have a public git tree? If not, I'd like to take this chance to
encourage you to setup one. The best work flow is to create a branch,
apply the patch and tell me the git URL and branch name to test.

Thanks,
Fengguang
