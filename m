Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbaFRBOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:14:40 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35060 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbaFRBOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:14:39 -0400
Date: Tue, 17 Jun 2014 18:14:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: werner <w.landgraf@ru.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: 3.16-rc1 problems vdso_addr , _mb_cache_entry_ , rtl8723au
In-Reply-To: <alpine.DEB.2.02.1406171530420.517@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1406171810210.22940@chino.kir.corp.google.com>
References: <web-91666686@zbackend1.aha.ru> <alpine.DEB.2.02.1406171530420.517@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, David Rientjes wrote:

>  - I can't reproduce your align_vdso_addr() problem, please send your 
>    .config
> 

Werner sent me his .config privately and, although it is 32-bit as 
expected, I cannot reproduce his align_vdso_addr() build issue with either 
Linus's tree nor linux-next-20140617.  I see no reason to think that it is 
a gcc versioning issue.
