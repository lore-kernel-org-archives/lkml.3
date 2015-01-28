Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbbA1ULl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:11:41 -0500
Received: from tex.lwn.net ([70.33.254.29]:35191 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbbA1UKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:10:50 -0500
Date: Wed, 28 Jan 2015 12:08:17 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, fengguang.wu@intel.com,
        Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Subject: Re: [PATCH] Documentation: fix blackfin gptimers-example build
 errors
Message-ID: <20150128120817.79aa615d@lwn.net>
In-Reply-To: <54B99244.8080404@infradead.org>
References: <54B99244.8080404@infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 14:35:48 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> Don't build the blackfin gptimers-example module when BFIN_GPTIMERS
> is not enabled. Allow the build when BFIN_GPTIMERS is =y or =m.

Applied to the docs tree, thanks.

jon
