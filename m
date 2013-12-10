Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3LJHvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:51:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3LJHvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:51:36 -0500
Date: Mon, 9 Dec 2013 23:53:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Axel Lin <axel.lin@ingics.com>, Rob Landley <rob@landley.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devtmpfs: Calling delete_path() only when necessary
Message-ID: <20131210075313.GA29984@kroah.com>
References: <1384589723.7840.1.camel@phoenix>
 <1386125959.1974.309@driftwood>
 <CAFRkauAzR=BqJGrMzN0i-tvi5mcQvyB9Kihk0YvxMpk=SWGvFA@mail.gmail.com>
 <20131209064654.GA20485@kroah.com>
 <CAFRkauCQdOyWbck+WtmNxtnenKyPAFNcqqUgcGSb1kAqj56sYA@mail.gmail.com>
 <20131209090530.GA4586@kroah.com>
 <CAFRkauCX+dLNiuoy7bPWO_ZE06OhorqYkkGh5pc8L3XyqNA-rg@mail.gmail.com>
 <CAFRkauBwUoE9109Oq9cgG71uOw5Uc+zZyDWsuCf47oLk-a2ngQ@mail.gmail.com>
 <20131210072633.GB27859@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210072633.GB27859@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:26:33PM +0800, Fengguang Wu wrote:
> > Hi, Fengguang
> > Can you help to add this patch to your test systems?
> > It's a one-line change, you can find the patch at
> > https://patchwork.kernel.org/patch/3192361/
> 
> Hi Axel,
> 
> Do you have a public git tree? If not, I'd like to take this chance to
> encourage you to setup one. The best work flow is to create a branch,
> apply the patch and tell me the git URL and branch name to test.

Unless you have a bunch of devices added and removed from the system
dynamically, you really aren't going to hit this codepath, so I don't
think your automated system really is going to help out much here,
sorry.

greg k-h
