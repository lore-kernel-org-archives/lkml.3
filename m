Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab3H0TDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:03:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40650 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3H0TDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:03:10 -0400
Message-ID: <521CF7D6.5090807@infradead.org>
Date: Tue, 27 Aug 2013 12:02:46 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 27 (ceph)
References: <20130827203008.1c54283d628ef706f51a866a@canb.auug.org.au>
In-Reply-To: <20130827203008.1c54283d628ef706f51a866a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/13 03:30, Stephen Rothwell wrote:
> Hi all,
> 
> I should know better than to take time off around -rc7 :-)
> 
> Changes since 20130822:
> 

on i386:

fs/built-in.o: In function `ceph_fallocate':
file.c:(.text+0x20b171): undefined reference to `__divdi3'


-- 
~Randy
