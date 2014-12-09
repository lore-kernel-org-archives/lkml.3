Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaLITqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:46:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaLITqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:46:04 -0500
Date: Tue, 9 Dec 2014 14:46:02 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: "Young, David" <dayoung@akamai.com>
Cc: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: selftests: question about git repos containing selftest.
Message-ID: <20141209194602.GB20166@kroah.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 02:22:42PM -0500, Young, David wrote:
> Greetings,
> 
> I'm trying out the new kernel selftests and was looking for the "bleeding edge" repository to clone.  According to the wiki https://kselftest.wiki.kernel.org/ this is the appropriate repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
> 
> However, I am finding newer and more frequent changes are in linux-next.
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> 
> Which should I clone for the most fresh changes?

Are you sure you are looking at the correct branch for that git repo?
Which one were you using?

thanks,

greg k-h
