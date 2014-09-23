Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaIWMkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:40:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaIWMkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:40:47 -0400
Date: Tue, 23 Sep 2014 14:40:45 +0200
From: Michal Marek <mmarek@suse.cz>
To: Matteo Croce <matteo@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 generated files in gitignore
Message-ID: <20140923124045.GA13913@sepie.suse.cz>
References: <CAFnufp3DcbG1DjXjD-sTL=1wYzu9dS5r1UXxGQwQjR11zRSBfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFnufp3DcbG1DjXjD-sTL=1wYzu9dS5r1UXxGQwQjR11zRSBfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:42:04AM +0200, Matteo Croce wrote:
> @@ -10,3 +10,4 @@ recordmcount
>  docproc
>  sortextable
>  asn1_compiler
> +bin2c

bin2c has been moved to scripts/basic, what you see is probably a
leftover from building an older kernel.

Michal
