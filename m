Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3JAOUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:20:34 -0400
Received: from one.firstfloor.org ([193.170.194.197]:57525 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3JAOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:20:32 -0400
Date: Tue, 1 Oct 2013 16:20:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 08/11] ext4: Fix end of group handling in
 ext4_mb_init_cache
Message-ID: <20131001142031.GG6931@two.firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-9-git-send-email-andi@firstfloor.org>
 <20131001124541.GB2097@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001124541.GB2097@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What's this change all about, and why is it included in this
> patch?

Sorry that was me fat-fingering git add. Ignore that hunk.

I needed it for the static analyzer, which does not understand asm goto.

-Andi
