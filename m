Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaI2OsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:48:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbaI2OsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:48:04 -0400
Message-ID: <5429711C.4060008@suse.cz>
Date: Mon, 29 Sep 2014 16:47:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Valentin Rothberg <valentinrothberg@gmail.com>, akpm@linux-foundation.org,
        Stefan Hengelein <stefan.hengelein@fau.de>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] checkkconfigsymbols.sh: reimplementation in python
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>	 <1411919729-5800-1-git-send-email-valentinrothberg@gmail.com> <1411986525.6334.32.camel@x220>
In-Reply-To: <1411986525.6334.32.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-29 12:28, Paul Bolle wrote:
>> +STMT = r"^\s*(?:if|select|depends\s+on)\s+" + EXPR
> 
> Could please make that "depends on"? Yes, it seems the yacc grammar
> accepts any amount of whitespace, but that doesn't make it right to use
> anything other than a single space.

But then lines that violate coding style would not be checked for real
errors.


> (Can the yacc grammar be tweaked to
> see "depends on" as one, well, token?)

I don't think this is a good idea. This is a style issue, why make it a
grammar issue.

Michal
