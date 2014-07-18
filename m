Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422745AbaGRNqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:46:36 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161127AbaGRNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:46:34 -0400
Message-ID: <53C92535.2010605@nod.at>
Date: Fri, 18 Jul 2014 15:46:29 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Borislav Petkov <bp@suse.de>
CC: akpm@linux-foundation.org, apw@canonical.com, joe@perches.com,
        tytso@mit.edu, dwalter@google.com, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
References: <1405611268-12463-1-git-send-email-richard@nod.at> <53C8CCE1.4000105@roeck-us.net> <20140718082324.GA31270@pd.tnic> <53C92332.5010807@roeck-us.net>
In-Reply-To: <53C92332.5010807@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.07.2014 15:37, schrieb Guenter Roeck:
> On 07/18/2014 01:23 AM, Borislav Petkov wrote:
>> On Fri, Jul 18, 2014 at 12:29:37AM -0700, Guenter Roeck wrote:
>>> First, 'abuse' is a relative term. It describes a use you
>>> (and possibly many others) may find objectionable, but that
>>> does not mean all uses are objectionable.
>>
>> Do you actually have a valid use case for keeping the cmdline switch ...
>>
> 
> I find it convenient to be able to check a new file before committing it
> and creating a patch. Also, I find it convenient to be able use it to clean
> up a file before I do heavy lifting with it. Yes, I understand the latter
> is discouraged nowadays, and I would not use it anymore outside my scope
> of responsibility unless specifically asked by the maintainer to do so,
> but in such cases it helps me a lot to be able to address the cleanup
> prior to the heavy lifting.

As capable kernel hacker you can still use a command like:
diff -urN /dev/null $file | ./scripts/checkpatch.pl -

Thanks,
//richard
