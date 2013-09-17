Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3IQRJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 13:09:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3IQRJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 13:09:36 -0400
Message-ID: <52388CC4.7040101@infradead.org>
Date: Tue, 17 Sep 2013 10:09:24 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] regulator: fix fatal kernel-doc error
References: <5237AB72.5020806@infradead.org> <20130917103238.GM21013@sirena.org.uk>
In-Reply-To: <20130917103238.GM21013@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/13 03:32, Mark Brown wrote:
> On Mon, Sep 16, 2013 at 06:08:02PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix fatal kernel-doc error in <linux/regulator/driver.h>:
>>
>> Error(include/linux/regulator/driver.h:52): cannot understand prototype: 'struct regulator_linear_range '
> 
> Applied with the first line redone, but this seems like really terrible
> quality of implementation for the kernel-doc stuff - it shouldn't
> explode over something readily copable with like this.  Should we also
> not pick this sort of thing up in -next?

/** means kernel-doc syntax and it was not in proper kernel-doc format,
but maybe it could just be a Warning instead of a fatal Error.

Ideally we should pick it up in -next, of course, but I doubt that anyone
is running kernel-doc on linux-next.  I used to do that, but there are
too many errors/warnings.  I suppose that I could just concentrate on
(fatal) Errors in linux-next and ignore the Warnings.

-- 
~Randy
