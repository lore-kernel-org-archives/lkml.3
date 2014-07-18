Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbaGROoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:44:00 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55235 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759330AbaGROn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:43:59 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C932AD.8050701@roeck-us.net>
Date: Fri, 18 Jul 2014 07:43:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@infradead.org>
CC: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        apw@canonical.com, joe@perches.com, tytso@mit.edu, dwalter@google.com,
        neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
References: <1405611268-12463-1-git-send-email-richard@nod.at> <53C8CCE1.4000105@roeck-us.net> <20140718082324.GA31270@pd.tnic> <53C92332.5010807@roeck-us.net> <53C92535.2010605@nod.at> <20140718142114.GA10475@infradead.org> <20140718142733.GD31270@pd.tnic>
In-Reply-To: <20140718142733.GD31270@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 07:27 AM, Borislav Petkov wrote:
> On Fri, Jul 18, 2014 at 07:21:14AM -0700, Christoph Hellwig wrote:
>> Or he could just use the existing -f flag.
>
> If you mean the -f flag to checkpatch, he's removing them both.
>
Two different 'he'.

>> I really don't understand why you're trying to educate people by
>> taking their toy away. They'll find another one in no time anyway.
>
> Maybe we should stop accepting patches created from running
> checkpatch...?
>

Thinking about it, Linux itself can be abused as well. We should
take it away to prevent that abuse from happening. That would
solve your checkpatch problem quite nicely and forever.

Guenter

