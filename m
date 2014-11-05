Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaKEXmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:42:25 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33108 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbaKEXmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:42:15 -0500
X-Sasl-enc: BsauizIoMyxIqQLSmkrvfax+08ihs+ZwEUjmFoeAzAzM 1415230933
Message-ID: <1415230929.2365.26.camel@perseus.themaw.net>
Subject: Re: [PATCH 04/13] autofs4 - change printks AUTOFS defined prints
From: Ian Kent <raven@themaw.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2014 07:42:09 +0800
In-Reply-To: <1415229642.6634.32.camel@perches.com>
References: <20141103081218.6215.85903.stgit@perseus.themaw.net>
	 <20141103081234.6215.82821.stgit@perseus.themaw.net>
	 <1415003136.17743.9.camel@perches.com>
	 <1415006418.6573.6.camel@perseus.themaw.net>
	 <1415025215.17743.12.camel@perches.com>
	 <1415228573.2365.24.camel@perseus.themaw.net>
	 <1415229642.6634.32.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 15:20 -0800, Joe Perches wrote:
> 
> > But idea of using pr_xxx() and pr_fmt() (actually that's too open to
> > name clashes so it would need to be named something like autofs_pr_fmt()
> > anyway) looks like it results in less readable code so I'd really prefer
> > not to do that.
> 
> Using pr_info/pr_debug (or any other pr_<level>) is a
> generic mechanism in the kernel.  Adding a
> #define pr_fmt is also generic thing that works with
> all the pr_<level> uses in a specific compilation unit.

LOL, so you recommend I look more closely, I will.
In the meantime I'll send the other patches to Andrew.

Ian

