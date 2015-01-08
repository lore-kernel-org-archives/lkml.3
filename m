Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbbAHK5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:57:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbbAHK5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:57:10 -0500
Message-ID: <54AE6284.8070300@suse.cz>
Date: Thu, 08 Jan 2015 11:57:08 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] make mrproper fix for v3.19-rc4
References: <20150108104933.GA25083@sepie.suse.cz>
In-Reply-To: <20150108104933.GA25083@sepie.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-08 11:49, Michal Marek wrote:
> Hi Linus,
> 
> make mrproper / distclean stopped removing the generated debian/
> directory in v3.16. Please pull the fix.
> 
> Thanks,
> Michal
> 
> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
> 
>   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git 

Sorry, git-request-pull for some reason does not see the commit in the
remote repository and did not print the branch name here. But it is
there, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

Thanks,
Michal
