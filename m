Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152Ab3DILcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:32:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35563 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935236Ab3DILcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:32:54 -0400
Message-ID: <1365507174.6865.31.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Check block comments outside of net
From: Joe Perches <joe@perches.com>
To: Matthijs Kooijman <matthijs@stdin.nl>
Cc: Andy Whitcroft <apw@canonical.com>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 04:32:54 -0700
In-Reply-To: <20130409111958.GG13691@login.drsnuggles.stderr.nl>
References: <20130409111958.GG13691@login.drsnuggles.stderr.nl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 13:19 +0200, Matthijs Kooijman wrote:
> There was some code checking block comments in net/ and drivers/net/,
> but nothing to check the regular block comment style.
[]
> Note that this patch rejects /** comments, since those are not mentioned
> in Codingstyle. They are used in practice though (around 1000 occurences
> in kernel/ alone), so perhaps they should be allowed and documented?

Those are kernel-doc comments and must be allowed.
see Documentation/kernel-doc-nano-HOWTO.txt

> Also, the new check only fires when the previous line is empty, just
> like the start of block comment check for net/. However, I couldn't find
> any documentation on why this restriction is needed?

I'm not that concerned about block comment style.
Maybe others are.

Please make it a --strict (CHK) only test for now.

