Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3IZGtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:49:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab3IZGte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:49:34 -0400
Message-ID: <5243D8FA.9090404@suse.cz>
Date: Thu, 26 Sep 2013 08:49:30 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [munlock] BUG: Bad page map in process killall5 pte:cf17e720
 pmd:05a22067
References: <20130926004028.GB9394@localhost>
In-Reply-To: <20130926004028.GB9394@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 02:40 AM, Fengguang Wu wrote:
> Hi Vlastimil,
> 
> FYI, this bug seems still not fixed in linux-next 20130925.

Hi,

I sent (including you) a RFC patch and later reviewed patch about week
ago. I assumed you would test it, but I probably should make that
request explicit, sorry. Anyway it was added to -mm an hour before your
mail.

Vlastimil
