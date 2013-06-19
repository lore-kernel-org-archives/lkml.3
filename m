Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3FSIUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:20:55 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48731 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3FSIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:20:53 -0400
Date: Wed, 19 Jun 2013 10:20:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: Basic perf PMU support for Haswell v14
Message-ID: <20130619082049.GA16572@gmail.com>
References: <1371515812-9646-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371515812-9646-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> v13:
> Various white space changes.
> v14:
> Rebased to 3.10-rc6

FYI, I'll have a look at your patches in the coming days.

As I warned you in the past your very slow, piecemail-wise, feet-dragging 
response to review feedback which has resulted in a supposedly simple perf 
driver submission reach an absurdly high version count of 14 over 6+ 
months has understandably put your patch-queue to the end of my (sadly 
long) TODO list - there's no need for you to keep pestering me or PeterZ 
over private mail when I'll take yet another look...

Thanks,

	Ingo
