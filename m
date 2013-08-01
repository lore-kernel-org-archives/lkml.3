Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3HAQsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:48:35 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42923 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab3HAQse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:48:34 -0400
Date: Thu, 01 Aug 2013 09:48:24 -0700
Message-ID: <20130801094824.Horde.bKc3Ppir309R_pFY3WInrtA@imap.linux.ibm.com>
From: Zach Levis <zml@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Zach Levis <zach@zachsthings.com>, Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-binfmts-better-handling-of-binfmt-loops.patch added to -mm
 tree
References: <20130731200805.GA29678@redhat.com>
 <20130801150532.GA15349@redhat.com>
 <20130801090223.Horde.UZGId5ir309R_oaPIezA7qA@imap.linux.ibm.com>
 <20130801163237.GA16070@redhat.com>
In-Reply-To: <20130801163237.GA16070@redhat.com>
User-Agent: Internet Messaging Program (IMP) H4 (5.0.22)
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080116-7182-0000-0000-000007F05EE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Oleg Nesterov <oleg@redhat.com>:

> On 08/01, Zach Levis wrote:
>>
>> So an example of what this would be used for (going into commit message
>> of a v2 with your earlier suggestions):
>
> Ah, so you are going to send v2, great.
>
> May I ask you to wait a little bit? Once again, I believe that
> search_binary_handler() needs a cleanup + minor fix. I'll try
> to send the patch today.

ok, I'll base v2 off of your patch


