Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3CALuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:50:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab3CALuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:50:16 -0500
Message-ID: <513095F6.2010000@suse.cz>
Date: Fri, 01 Mar 2013 12:50:14 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, jlec@gentoo.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] menuconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org> <1362052335-17913-1-git-send-email-jlec@gentoo.org> <201302281916.00257.yann.morin.1998@free.fr>
In-Reply-To: <201302281916.00257.yann.morin.1998@free.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.2.2013 19:16, Yann E. MORIN wrote:
> On Thursday 28 February 2013 jlec@gentoo.org wrote:
>> This patch replaces the old heuristic for detection of ncurses libs for
>> linking the ncurses menuconfig dialog by the use of the config scripts.
>> This results in the requirement of ncurses version 5.6 or newer for menuconfig.
> 
> As you said, ncurses started bundling these files with ncurses-5.6,
> which was released in 2006.
> 
> OTOH, RHEL4 is still a widely used distro, and was released in 2005,
> so is using an ncurses older than 5.6, so I'm afraid we can't drop
> the legacy code like that.

Yes, please keep support for older libraries if it does not require too
much effort.

Michal
