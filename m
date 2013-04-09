Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936444Ab3DILhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:37:07 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:33046 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935190Ab3DILhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:37:05 -0400
Date: Tue, 9 Apr 2013 13:37:02 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Check block comments outside of net
Message-ID: <20130409113701.GI13691@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
	Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
	linux-kernel@vger.kernel.org
References: <20130409111958.GG13691@login.drsnuggles.stderr.nl>
 <1365507174.6865.31.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365507174.6865.31.camel@joe-AO722>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, Apr 09, 2013 at 04:32:54AM -0700, Joe Perches wrote:
> > Note that this patch rejects /** comments, since those are not mentioned
> > in Codingstyle. They are used in practice though (around 1000 occurences
> > in kernel/ alone), so perhaps they should be allowed and documented?
> 
> Those are kernel-doc comments and must be allowed.
> see Documentation/kernel-doc-nano-HOWTO.txt
I just realized that as well, I'll send an updated patch.

> > Also, the new check only fires when the previous line is empty, just
> > like the start of block comment check for net/. However, I couldn't find
> > any documentation on why this restriction is needed?
> 
> I'm not that concerned about block comment style.
> Maybe others are.
I'm not entirely sure if this is a answer to my question? Or are you
saying you don't really care about this and thus don't know the answer?
:-)

> Please make it a --strict (CHK) only test for now.
Ok.

Gr.

Matthijs
