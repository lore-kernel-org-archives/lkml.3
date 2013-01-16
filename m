Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3APB1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:27:32 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37895 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab3APB1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:27:31 -0500
Message-ID: <50F601F7.3010000@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 17:27:19 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 14/17] mm/memory_hotplug: factor out zone+pgdat growth.
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com> <1358295894-24167-15-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1358295894-24167-15-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011601-7182-0000-0000-000004766E5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 04:24 PM, Cody P Schafer wrote:
> Create a new function grow_pgdat_and_zone() which handles locking +
> growth of a zone & the pgdat which it is associated with.

Why is this being factored out?  Will it be reused somewhere?

