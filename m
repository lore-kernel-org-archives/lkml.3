Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3JHHr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:47:26 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:11253 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab3JHHrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:47:21 -0400
Message-ID: <5253B860.5030604@nsn.com>
Date: Tue, 08 Oct 2013 09:46:40 +0200
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: ext Brian Norris <computersforpeace@gmail.com>
CC: linux-mtd@lists.infradead.org, Joern Engel <joern@lazybastard.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: phram: Make phram 64-bit compatible
References: <524C4CF5.7060601@nsn.com> <20131007174943.GB23337@ld-irv-0074.broadcom.com>
In-Reply-To: <20131007174943.GB23337@ld-irv-0074.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 611
X-purgate-ID: 151667::1381218403-00005753-49411BB9/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 10/07/2013 07:49 PM, ext Brian Norris wrote:
> Are we (MTD) holding a revolutionary position against the standard
> kernel libraries, which recognize [KkMmGg] prefixes, but not [kMG]i
> prefixes? Should we extend memparse() to accept either form? Or would
> doing so simply pollute the library and not really satisfy anyone?

I was also irritated re-inventing the wheel here, but the problem is --
millions of people out there have their startup scripts and uboot environments
for phram, who expect this just to work with the next kernel upgrade...

-- 
Best regards,
Alexander Sverdlin.
