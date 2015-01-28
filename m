Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbbA2B1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:27:33 -0500
Received: from tex.lwn.net ([70.33.254.29]:35896 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbbA2B1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:27:30 -0500
Date: Wed, 28 Jan 2015 12:00:33 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DocBook: Do not exceed argument list limit
Message-ID: <20150128120033.5c1fe43f@lwn.net>
In-Reply-To: <1422268277-5333-1-git-send-email-mmarek@suse.cz>
References: <1422268277-5333-1-git-send-email-mmarek@suse.cz>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 11:31:17 +0100
Michal Marek <mmarek@suse.cz> wrote:

> Use find + xargs to compress the generated manpages. Without this patch,
> the build can fail with
> 
>     gzip -f Documentation/DocBook/man/*.9
>     /bin/bash: /usr/bin/gzip: Argument list too long

That is a lot of files in that directory these days...applied to the docs
tree, thanks.

jon
