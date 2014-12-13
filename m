Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaLMVVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 16:21:01 -0500
Received: from syn.loicp.eu ([176.31.96.212]:53264 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbaLMVVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 16:21:00 -0500
Date: Sat, 13 Dec 2014 22:20:52 +0100
From: Loic Pefferkorn <loic@loicp.eu>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com, jun.j.tian@intel.com,
        octavian.purdila@intel.com, nnk@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: goldfish: Fix minor coding style
Message-ID: <20141213212051.GB6979@iron>
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
 <20141213190705.0faaf119@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141213190705.0faaf119@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 07:07:05PM +0000, One Thousand Gnomes wrote:
> 
> Pointless churn. It makes it less readable if anything, and it removes
> the type safety as you are now checking against 0 not (void *)0
> 
> NAK
> 
> Alan

The type safety is an interesting point I was not aware of.

Just in case, do you have something for me on your todo list?

-- 
Cheers,
Loïc
