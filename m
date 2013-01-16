Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3APGpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:45:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:36190 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab3APGpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:45:41 -0500
Date: Tue, 15 Jan 2013 22:46:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, cwchoi00@gmail.com
Subject: Re: [GIT PULL] extcon for 3.8-rc4
Message-ID: <20130116064640.GB6087@kroah.com>
References: <50F5067A.2060104@samsung.com>
 <20130115113719.GD1748@kroah.com>
 <CAGTfZH2r9TaNEPQ5am-UFwQd9t_qegxfo3MMOwJxvfctid7=-Q@mail.gmail.com>
 <20130115121356.GA2349@kroah.com>
 <CAGTfZH27VUuqqx5b4trMSDDDceWqwHE2wqPZdLbWvvBvbrzpKg@mail.gmail.com>
 <20130115134941.GA25473@kroah.com>
 <50F620BB.9010602@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F620BB.9010602@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 12:38:35PM +0900, Chanwoo Choi wrote:
> >>  OK, I will resend pull-request to include only bugfixes patch in 3.8.
> >> After released v3.8-rc7 or 3.8-rc8 kernel, I will send pull-request of extcon
> >> to include new feature patches of extcon driver in 3.9.
> > 
> > No, you can send me that pull request now as well, I have two different
> > branches, one to go to Linus for this release, and one for the next one.
> > Both of them show up in linux-next.  You should have the same.
> > 
> > So you can send me two pull requests now, does that make more sense?
> > 
> I understand and thanks for your comment. I will resend only one pull-request for
> extcon to include it for -next branch. I don't send separate pull-request
> for bugfixes patch.

Why not send a bugfix pull request?  Are none of these for 3.8?  If so,
fine, but be sure to go through them to determine this.

thanks,

greg k-h
