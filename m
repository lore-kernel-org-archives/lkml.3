Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbaGRORo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:17:44 -0400
Received: from smtp-out-181.synserver.de ([212.40.185.181]:1085 "EHLO
	smtp-out-181.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbaGRORm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:17:42 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 836
Message-ID: <53C92C86.2030408@metafoo.de>
Date: Fri, 18 Jul 2014 16:17:42 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org
CC: apw@canonical.com, joe@perches.com, tytso@mit.edu, dwalter@google.com,
        bp@suse.de, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
References: <1405611268-12463-1-git-send-email-richard@nod.at>
In-Reply-To: <1405611268-12463-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 05:34 PM, Richard Weinberger wrote:
[...]
> In order to deal with that bad habit let's remove the --file option
> and bring checkpatch.pl back to its original purpose.

I don't think this is a good solution the problem and I'm not sure how 
successful it will actually be at fixing the problem. How about instead 
properly documenting that single line trivial style cleanup patches are not 
really helpful and people should not send them? (Maybe add a check to 
checkpatch.pl that emits a warning if the patch is a trivial style cleanup ;))

--file is a in my opinion useful option and at least I use it on a regular 
basis.

- Lars
