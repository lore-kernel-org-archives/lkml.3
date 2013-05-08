Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3EHCiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:38:08 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61895 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3EHCiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:38:06 -0400
Date: Tue, 7 May 2013 19:38:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: Misc: fix warnings, unsigned long will never
 < 0
Message-ID: <20130508023803.GB19842@kroah.com>
References: <5160E37C.3020007@asianux.com>
 <5160E7EA.3050406@asianux.com>
 <5189B76C.9050606@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5189B76C.9050606@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 10:24:44AM +0800, Chen Gang wrote:
> Hello Maintainers:
> 
> Please help check, when you have time.
> 
> Thanks.
> 
> On 2013年04月07日 11:28, Chen Gang wrote:

<snip>

You sent a cleanup patch in the middle of the merge window, when we
can't take any patches at the moment due to other work, and expect a
review in less than 24 hours?

Please be realistic, I'll get to this eventually (i.e. next week at the
earliest.)

Patience is a virtue.

greg "someone owes me some virtue" k-h
