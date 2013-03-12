Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3CLBFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:05:04 -0400
Received: from tundra.namei.org ([65.99.196.166]:60342 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab3CLBFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:05:03 -0400
Date: Tue, 12 Mar 2013 12:05:53 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
cc: Oleg Nesterov <oleg@redhat.com>, lucas.de.marchi@gmail.com,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] KEYS: split call to call_usermodehelper_fns()
In-Reply-To: <1363049291-946-4-git-send-email-lucas.demarchi@profusion.mobi>
Message-ID: <alpine.LRH.2.02.1303121205090.25612@tundra.namei.org>
References: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi> <1363049291-946-4-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013, Lucas De Marchi wrote:

> Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
> calling call_usermodehelper_fns(). In case there's an OOM in this last
> function the cleanup function may not be called - in this case we would
> miss a call to key_put().
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>

Acked-by: James Morris <james.l.morris@oracle.com>




-- 
James Morris
<jmorris@namei.org>
