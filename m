Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab3BSOx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:53:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:44560 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975Ab3BSOx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:53:28 -0500
Message-ID: <512391DA.6090706@windriver.com>
Date: Tue, 19 Feb 2013 09:53:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Jiri Kosina <jkosina@suse.cz>, <linux-doc@vger.kernel.org>,
        Rob Landley <rob@landley.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: update top level 00-INDEX file with new
 additions
References: <1360873254-28937-1-git-send-email-paul.gortmaker@windriver.com> <alpine.LNX.2.00.1302181039000.17024@pobox.suse.cz> <51224F70.9050806@infradead.org>
In-Reply-To: <51224F70.9050806@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-18 10:57 AM, Randy Dunlap wrote:
> On 02/18/13 01:39, Jiri Kosina wrote:
>> On Thu, 14 Feb 2013, Paul Gortmaker wrote:
>>
>>> It seems there are about 80 new, but undocumented addtions at
>>> the top level Documentation directory.  This fixes up the top
>>> level 00-INDEX by adding new entries and deleting a couple orphans.
>>> Some subdirs could probably still use a check/cleanup too though.
> 
> After this patch, I would prefer to see a requirement that each Documentation/
> file contain a "topic" line and then generate INDEX files from those automatically...
> 
> comments?

Rules can sometimes be so inflexible as to prevent additions.
I think I'd rather see a makefile target that does some sanity
checks, so that kernel janitors and the like are more apt to
send trivial patches before it falls behind by 80+ entries like
it was just recently.   Just my $0.02 opinion.

P.
--

> 
> 
>>> Acked-by: Rob Landley <rob@landley.net>
>>> Cc: Jiri Kosina <trivial@kernel.org>
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>> ---
>>>
>>> [vectoring this via trivial tree as requested by Rob]
>>
>> Applied, thanks.
> 
> 
