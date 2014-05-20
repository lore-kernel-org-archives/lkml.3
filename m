Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaETArx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:47:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaETArw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:47:52 -0400
Date: Tue, 20 May 2014 09:45:43 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] extcon next for v3.16
Message-ID: <20140520004543.GA954@kroah.com>
References: <537AA18A.9080900@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537AA18A.9080900@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 09:27:54AM +0900, Chanwoo Choi wrote:
> Dear Greg,
> 
> This is extcon-next full request for v3.16. I add detailed description of this
> pull request on below. Please pull extcon with following updates.
> 
> I report you about merge of MAX77836 patchset from MFD git repo(Lee Jones).
> The MAX77836 patchset in this pull request has the dependency on various
> subsystem(MFD/Regulator/Extcon). To protect merge conflit, firstly MFD Maintainer
> created Immutable branch(branch: ib-mfd-extcon-3.16) and then I merged it on
> extcon-next branch.
> 
> The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:
> 
>   Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.16

Pulled and pushed out, thanks.

greg k-h
