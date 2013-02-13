Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325Ab3BMXw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:52:59 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62268 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3BMXw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:52:57 -0500
Date: Wed, 13 Feb 2013 15:52:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>, kyungmin.park@samsung.com
Subject: Re: [GIT PULL] extcon for 3.9
Message-ID: <20130213235254.GB19813@kroah.com>
References: <511C24B7.4000802@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511C24B7.4000802@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 08:41:43AM +0900, Chanwoo Choi wrote:
> Hi Greg,
> 
> This pull-reqeust patchset is based on char-misc-next branch(char-misc.git).
> Please pull extcon with following updates.
> 
> Best regards,
> Chanwoo Choi
> 
> The following changes since commit 19d3243e797c2abc02a214d3cec9fefa5dc048ff:
> 
>   extcon: max77693: Remove unnecessary goto statement to improve
> readability (2013-02-13 08:35:44 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org:/pub/scm/linux/kernel/git/chanwoo/extcon.git
> tags/extcon-for-3.9

$ git pull git://git.kernel.org:/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-for-3.9 
fatal: Unable to look up git.kernel.org (port <none>) (Servname not supported for ai_socktype)

You added an extra ':' in that url, how did you generate it?  Please be
more careful in the future.

I fixed it by hand...

thanks,

greg k-h
