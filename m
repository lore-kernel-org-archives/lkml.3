Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaBROfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:35:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42179 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbaBROff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:35:35 -0500
Message-ID: <53036F93.3030803@zytor.com>
Date: Tue, 18 Feb 2014 06:34:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
CC: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Link Time Optimization patchkit v3
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 06:28 AM, Andi Kleen wrote:
> LTO allows the compiler to do global optimization over the whole kernel.
> 
> Updated version of the LTO patchkit, mainly for fixing Sam's review
> comments.  I also rebased to 3.14-rc3 and added a fix for bloat-o-meter
> with gcc 4.9
> 
> See the individual patches for a detailed description
> 
> Dependencies: asmlinkage patchkit (posted two weeks ago), kallsyms patchkit
> (plus LTO capable toolchain, see documentation)
> 
> Full git tree is in
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc lto-3.14
> 

Michal, Sam, when this patchset is done, do you want to take it in your
tree or should I?

	-hpa



