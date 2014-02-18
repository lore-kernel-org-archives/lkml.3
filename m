Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaBRWRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:17:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaBRWRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:17:54 -0500
Message-ID: <5303DC0D.6090209@redhat.com>
Date: Tue, 18 Feb 2014 17:17:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>, linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, akpm@linux-foundation.org, james.leddy@redhat.com
Subject: Re: [PATCH] fs/proc/meminfo: meminfo_proc_show(): fix typo in comment
References: <20140218170027.00bcf592@redhat.com>
In-Reply-To: <20140218170027.00bcf592@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 05:00 PM, Luiz Capitulino wrote:
> It should read "reclaimable slab" and not "reclaimable swap".

Doh! My bad. Thanks for fixing it, Luiz!

> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
