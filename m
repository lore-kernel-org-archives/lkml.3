Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbaGPEQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:16:52 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:50003 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaGPEQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <1405481937.14773.8.camel@joe-AO725>
References: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>
	<1405481937.14773.8.camel@joe-AO725>
Date: Wed, 16 Jul 2014 00:16:48 -0400
Message-ID: <CAPDOMVhSosu-WZkBo+mKs3mJ+2+W-rBq0LFUnU_Lnzn=jR7=wg@mail.gmail.com>
Subject: Re: Checkpatch Feature Idea: Search directory for files with errors
 and warnings with -d argument
From: Nick Krause <xerofoify@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
        robh@kernel.org, florian.vaussard@epfl.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 11:38 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-07-15 at 22:50 -0400, Nick Krause wrote:
>> I may have not found it myself but if it doesn't exist can we write a
>> feature for checkpatch to be able to recursively
>> search a directory structure with a -d argument in order to make it
>> easier to search larger directories for files that still
>> need cleanup for files having kernel coding style issues.
>linux-kernel@vger.kernel.org
> xargs already works fine.
>
> git ls-files <dir>/*.[ch] | xargs ./scripts/checkpatch.pl -f
>
> I suggest you only use anything like this
> on staging directories.
>
>

Thanks Joe,
That was what I needed to known :). I was hitting some errors in arch,
so I will run that to see if there are any others.
Cheers Nick
