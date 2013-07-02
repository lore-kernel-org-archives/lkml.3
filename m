Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3GBEnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:43:17 -0400
Received: from www.sr71.net ([198.145.64.142]:60063 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3GBEnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:43:16 -0400
Message-ID: <51D25A71.3060007@sr71.net>
Date: Mon, 01 Jul 2013 21:43:29 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: madvise: MADV_POPULATE for quick pre-faulting
References: <20130627231605.8F9F12E6@viggo.jf.intel.com> <20130628054757.GA10429@gmail.com> <51CDB056.5090308@sr71.net> <51CE4451.4060708@gmail.com> <51D1AB6E.9030905@sr71.net> <20130702023748.GA10366@gmail.com>
In-Reply-To: <20130702023748.GA10366@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 07:37 PM, Zheng Liu wrote:
> FWIW, it would be great if we can let MAP_POPULATE flag support shared
> mappings because in our product system there has a lot of applications
> that uses mmap(2) and then pre-faults this mapping.  Currently these
> applications need to pre-fault the mapping manually.

Are you sure it doesn't?  From a cursory look at the code, it looked to
me like it would populate anonymous and file-backed, but I didn't
double-check experimentally.
