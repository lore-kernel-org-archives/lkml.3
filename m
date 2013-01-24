Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3AXT7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:59:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab3AXT7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:59:11 -0500
Message-ID: <51019284.4070900@suse.cz>
Date: Thu, 24 Jan 2013 20:59:00 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: rusty@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] MODSIGN: Specify the hash algorithm on sign-file
 command line
References: <1358955044-27407-3-git-send-email-mmarek@suse.cz> <1358955044-27407-1-git-send-email-mmarek@suse.cz> <28722.1359040632@warthog.procyon.org.uk>
In-Reply-To: <28722.1359040632@warthog.procyon.org.uk>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 24.1.2013 16:17, David Howells napsal(a):
> Michal Marek <mmarek@suse.cz> wrote:
> 
>> +our ($opt_v, $opt_a);
> 
> Should this be 'our' or 'my'?

These are global variables set by getopts(), so they need to be declared
'our'. But I can change it to use the two-argument version of getopts,
that does not use global variables.

Michal

