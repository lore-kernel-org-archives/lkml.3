Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3HTFXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:23:09 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59472 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3HTFXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:23:07 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
In-Reply-To: <20130819160542.38e4a91b568c0a15f1068e09@linux-foundation.org>
References: <CAKZGPAOwpEcxxZJUbmUVL1J+enXGhFbbvyZ7L3uWDkPbwKnbyQ@mail.gmail.com>
	<20130819160542.38e4a91b568c0a15f1068e09@linux-foundation.org>
Date: Tue, 20 Aug 2013 10:53:06 +0530
X-Google-Sender-Auth: 6xewmShwfxIW-YSwxEorySASF84
Message-ID: <CAKZGPAOC0cZDvsWx-jFKnKtGPjjdST-=UgTU+WoVE0P6Q0ULTA@mail.gmail.com>
Subject: Re: [PATCH] SeqFile: Fix overflow condition
From: Arun KS <arunks.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>,
        Bruce Fields <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Aug 20, 2013 at 4:35 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 19 Aug 2013 17:02:37 +0530 Arun KS <arunks.linux@gmail.com> wrote:
>
>> seq_path()/seq_commit() is treating a d_path() failure as an overflow
>> condition, but it isn't.
>
> This is too brief.  When fixing a bug please always describe the
> user-visible effects of the bug.  And unless it's utterly obvious,
> provide a description of how you set about fixing that bug.
>
I ll address this and will send a patch soon.

Thanks,
Arun
