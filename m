Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaFKQnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:43:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbaFKQnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:43:40 -0400
Message-ID: <5398872C.4080607@redhat.com>
Date: Wed, 11 Jun 2014 12:43:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Steven Miao (Steven Miao)" <realmz6@gmail.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Jerome Marchand <jmarchan@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Davidlohr Bueso <davidlohr@hp.com>,
        Choi Gi-yong <yong@gnoy.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Chen Gang <gang.chen@asianux.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: per-thread vma cache fix
References: <1402396130-22368-1-git-send-email-realmz6@gmail.com>
In-Reply-To: <1402396130-22368-1-git-send-email-realmz6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 06:28 AM, Steven Miao (Steven Miao) wrote:
> From: Steven Miao <realmz6@gmail.com>
> 
> mm could be removed from current task struct, using previous vma->vm_mm

> Signed-off-by: Steven Miao <realmz6@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
