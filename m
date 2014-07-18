Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbaGRIQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:16:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55152 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729AbaGRIQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:16:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C8CCE1.4000105@roeck-us.net>
Date: Fri, 18 Jul 2014 00:29:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
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

On 07/17/2014 08:34 AM, Richard Weinberger wrote:
> checkpatch.pl is a nice tool to find issues in patches.
> Sadly this tool gets more and more  abused by various people to create
> style cleanups for source files within the kernel.
> In order to deal with that bad habit let's remove the --file option
> and bring checkpatch.pl back to its original purpose.
>

I have a number of problems with this patch.

First, 'abuse' is a relative term. It describes a use you
(and possibly many others) may find objectionable, but that
does not mean all uses are objectionable.

Second, just because something is abused doesn't mean it would be
a good idea to take it away. Many of the amendmends to the US
Constitution can be abused. Should freedom of speech be taken away
because it can be abused ? I hope not. Many drugs can be abused.
Should they be taken away ? I hope not. And so on.

Using your argument, you can take away anything that can be abused,
which is pretty much everything. Not a good idea.

Guenter

