Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaFRPeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:34:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaFRPeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:34:11 -0400
Message-ID: <53A1B16F.7090805@suse.cz>
Date: Wed, 18 Jun 2014 17:34:07 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Fix tar-pkg with relative $(objtree)
References: <20140617223854.GC6168@fieldses.org> <1403101583-15275-1-git-send-email-mmarek@suse.cz> <20140618152912.GD17790@fieldses.org>
In-Reply-To: <20140618152912.GD17790@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 18.6.2014 17:29, J. Bruce Fields napsal(a):
> On Wed, Jun 18, 2014 at 04:26:23PM +0200, Michal Marek wrote:
>> Commit 7e1c0477 (kbuild: Use relative path for $(objtree)) assumes that
>> the build process does not change its working directory. make tar-pkg
>> was a couterexample, fix this by changing directory only for the tar
>> command and not for the whole script, which at one point references the
>> now relative $(objtree).
> 
> Works for me, thanks.--b.

Thanks for testing!

Michal

