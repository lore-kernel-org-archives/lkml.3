Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaBONiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 08:38:19 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:53963 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaBONiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:38:17 -0500
Date: Sat, 15 Feb 2014 14:38:14 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        mmarek@suse.cz
Subject: Re: Updated Link-Time-Optimization patchkit
Message-ID: <20140215133814.GA287@x4>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.02.14 at 22:21 +0100, Andi Kleen wrote:
> This is the updated LTO patchkit for 3.14-rc2.  LTO allows
> the compiler to do global optimization over the whole kernel.

It is mildly annoying that one couldn't use vanilla binutils. Have you
already opened bugs on sourceware.org/bugzilla/ to get this fixed for
gold and ld.bfd?

-- 
Markus
