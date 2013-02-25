Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3BYRps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:45:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab3BYRpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:45:44 -0500
Message-ID: <512BA33C.6060506@redhat.com>
Date: Mon, 25 Feb 2013 12:45:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Aaron Tomlin <atomlin@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, glommer@parallels.com
Subject: Re: [PATCH v2] mm: slab: Verify the nodeid passed to ____cache_alloc_node
References: <591256534.8212978.1361812690861.JavaMail.root@redhat.com>
In-Reply-To: <591256534.8212978.1361812690861.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 12:18 PM, Aaron Tomlin wrote:

> mm: slab: Verify the nodeid passed to ____cache_alloc_node
>
> If the nodeid is > num_online_nodes() this can cause an
> Oops and a panic(). The purpose of this patch is to assert
> if this condition is true to aid debugging efforts rather
> than some random NULL pointer dereference or page fault.
>
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
