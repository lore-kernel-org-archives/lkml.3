Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaG3Sol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:44:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49113 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaG3Soj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:44:39 -0400
Date: Wed, 30 Jul 2014 20:44:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Dirk Gouders <dirk@gouders.net>
Subject: Re: [PATCH 1/2] kbuild: Support split debug info v4
Message-ID: <20140730184436.GM18735@two.firstfloor.org>
References: <1406675493-2539-1-git-send-email-andi@firstfloor.org>
 <53D8F816.7040104@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D8F816.7040104@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The failure mode with ccache is that the *.dwo files are not stored, but
> the build proceeds, right? This is at least what I'm seeing. I'm just

That's right.

> wondering if the config option should be inverted to make
> all{yes,mod}config builds happy. But it's probably not necessary if the
> build passes.

Ok I'll not change it then and only resend the other patch.

-Andi
