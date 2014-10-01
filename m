Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaJAVVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:21:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbaJAVVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:21:31 -0400
Message-ID: <542C7058.8090001@suse.cz>
Date: Wed, 01 Oct 2014 23:21:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kbuild: fake the "Entering directory ..." message
 more simply
References: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com> <1410260544-22657-2-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1410260544-22657-2-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 9.9.2014 13:02, Masahiro Yamada napsal(a):
> Commit c2e28dc975ea87feed84415006ae143424912ac7
> (kbuild: Print the name of the build directory)
> added a gimmick to show the "Entering directory ...".
> 
> Instead of echoing the hard-coded message (that is, we need to know
> the exact message), moving --no-print-directory would be easier.

It now prints the localized text for me. But I guess I'm getting what I
asked for :). Applied to kbuild.git#kbuild.

Michal
