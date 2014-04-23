Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbaDWHXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:23:36 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:51294 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaDWHXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:23:33 -0400
Date: Wed, 23 Apr 2014 09:23:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, dhowells@redhat.com,
        broonie@linaro.org, benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 18/18] asm-generic: io: define relaxed accessor macros
 unconditionally
Message-ID: <20140423072327.GA1589@ravnborg.org>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <1397742261-15621-19-git-send-email-will.deacon@arm.com>
 <5356782A.9050809@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356782A.9050809@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I expect that all archs should use asm-generic/io.h to clean
> architecture io.h exactly I have done it for Microblaze.
I took a quick look at sparc32 - doing this is a nice cleanup.
Thanks for the hint.

	Sam
