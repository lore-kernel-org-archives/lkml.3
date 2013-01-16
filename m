Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3APBUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:20:43 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:45576 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab3APBUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:20:38 -0500
Message-ID: <50F6005B.1010900@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 17:20:27 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>
Subject: Re: [PATCH 02/17] mmzone: add various zone_*() helper functions.
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com> <1358295894-24167-3-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1358295894-24167-3-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011601-5518-0000-0000-00000AC5349F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 04:24 PM, Cody P Schafer wrote:
> +static inline bool zone_is_empty(struct zone *zone)
> +{
> +	return zone->spanned_pages == 0;
> +}

Why did you choose spanned_pages for this?

