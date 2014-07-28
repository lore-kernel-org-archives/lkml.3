Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaG1GMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:12:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaG1GM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:12:28 -0400
Date: Sun, 27 Jul 2014 23:12:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        =?utf-8?B?7J6E6re87Iud?= <geunsik.lim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon next for v3.17
Message-ID: <20140728061201.GB753@kroah.com>
References: <53D1A796.8030607@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D1A796.8030607@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 09:40:54AM +0900, Chanwoo Choi wrote:
> Dear Greg,
> 
> This is extcon-next full request for v3.17. I add detailed description of this
> pull request on below. Please pull extcon with following updates.
> 
> I report you about merge of MAX77693 patchset from MFD git repo(Lee Jones).
> The MAX77693 patchset in this pull request has the dependency on various
> subsystem(MFD/Regulator/Extcon). To protect merge conflit, firstly MFD Maintainer
> created Immutable branch(branch: ib-mfd-extcon-regulator) and then I merged it on
> extcon-next branch.
> 
> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.17

Pulled and pushed out, thanks.

greg k-h
