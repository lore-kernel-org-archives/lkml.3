Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937095Ab3DJX4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:56:55 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:43470 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808Ab3DJX4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:56:54 -0400
Message-ID: <5165FC42.6060304@gmail.com>
Date: Wed, 10 Apr 2013 19:56:50 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kosaki.motohiro@gmail.com
Subject: Re: [PATCH] mm: madvise: complete input validation before taking
 lock
References: <u0leheij6gt.fsf@orc05.imf.au.dk>
In-Reply-To: <u0leheij6gt.fsf@orc05.imf.au.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/10/13 7:45 PM), Rasmus Villemoes wrote:
> In madvise(), there doesn't seem to be any reason for taking the
> &current->mm->mmap_sem before start and len_in have been
> validated. Incidentally, this removes the need for the out: label.
> 
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Looks good.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


