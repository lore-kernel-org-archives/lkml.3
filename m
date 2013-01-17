Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3AQAQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 19:16:34 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48821 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab3AQAQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 19:16:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130117092536.f1a4e0ed60610845cc919b15@canb.auug.org.au>
References: <20130117092536.f1a4e0ed60610845cc919b15@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 17 Jan 2013 00:16:12 +0000
X-Google-Sender-Auth: e4A-hzhFiJfoXFfZu4dvj4mShzw
Message-ID: <CACxGe6udrYHtVwf50YsPCcrQ-3fCFEXP7pr2AGeVL=ja5VmZDA@mail.gmail.com>
Subject: Re: linux-next: error when fething the git.secretlab.ca trees
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:25 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Fetching the trees from git.secretlab.ca over the past few days has
> produced this error:
>
> fatal: The remote end hung up unexpectedly

Thanks for letting me know. I was mucking about with my server to
enable gitolite. I probably messed it up. I've just tried to fix it.
Let me know if it is working now.

g.
