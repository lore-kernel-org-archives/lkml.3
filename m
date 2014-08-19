Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaHSXtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 19:49:15 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48374 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHSXtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 19:49:13 -0400
Date: Wed, 20 Aug 2014 01:49:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bertrand Jacquin <beber@meleeweb.net>
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 2/3] kbuild: handle module compression while running
 'make modules_install'.
Message-ID: <20140819234912.GL4120@two.firstfloor.org>
References: <1408215016-1848-1-git-send-email-beber@meleeweb.net>
 <1408215016-1848-3-git-send-email-beber@meleeweb.net>
 <87lhqkmxdl.fsf@tassilo.jf.intel.com>
 <20140819152238.GB2164@lady-voodoo.exosec.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819152238.GB2164@lady-voodoo.exosec.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I understand your concern about this, but does is make sense to not use
> -9 when then following files use gzip or other compression tools with -9 :

Just because someone else makes mistakes doesn't mean that you should
make them too.

-Andi

