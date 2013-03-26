Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3CZXsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:48:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab3CZXsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:48:25 -0400
Message-ID: <515233C8.40205@suse.cz>
Date: Wed, 27 Mar 2013 00:48:24 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Discard previous signature when signing modules
References: <1364338701-24306-1-git-send-email-mmarek@suse.cz> <960.1364340890@warthog.procyon.org.uk>
In-Reply-To: <960.1364340890@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.3.2013 00:34, David Howells wrote:
> Michal Marek <mmarek@suse.cz> wrote:
> 
>> The format only supports one signature, so discard any previous
>> signature before signing the module.
> 
> That's not totally true.  The format does not preclude multiple signatures.
> You can just add another signature block on the end that signs everything
> inside of that, including all previous signatures.  The alteration to the code
> to check all of them would be very small, I think.

The question is if this would be useful and desired, as opposed to
supporting a list of signatures that all sign the *same* message. My bet
is that such chain of signatures is more likely going to indicate error
than intention. But I don't care much, I haven't run into this myself, I
just thought that others migh do.

Michal
