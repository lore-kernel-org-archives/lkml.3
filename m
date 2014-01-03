Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaACSXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:23:41 -0500
Received: from www.sr71.net ([198.145.64.142]:58454 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaACSXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:23:40 -0500
Message-ID: <52C70024.1060605@sr71.net>
Date: Fri, 03 Jan 2014 10:23:32 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3 00/11] Intermix Lowmem and vmalloc
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 01:53 PM, Laura Abbott wrote:
> The goal here is to allow as much lowmem to be mapped as if the block of memory
> was not reserved from the physical lowmem region. Previously, we had been
> hacking up the direct virt <-> phys translation to ignore a large region of
> memory. This did not scale for multiple holes of memory however.

How much lowmem do these holes end up eating up in practice, ballpark?
I'm curious how painful this is going to get.
