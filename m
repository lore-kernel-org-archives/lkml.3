Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3AYVuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:50:52 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:43038 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3AYVuu (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 25 Jan 2013 16:50:50 -0500
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 16:50:50 EST
User-Agent: K-9 Mail for Android
In-Reply-To: <9497.1359072618@warthog.procyon.org.uk>
References: <1359062429-27295-3-git-send-email-mmarek@suse.cz> <1359062429-27295-1-git-send-email-mmarek@suse.cz> <9497.1359072618@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 3/4] MODSIGN: Add -s <signature> option to sign-file
From: Michal Marek <mmarek@suse.cz>
Date: Fri, 25 Jan 2013 22:30:13 +0100
To: David Howells <dhowells@redhat.com>
CC: rusty@ozlabs.org, linux-kernel@vger.kernel.org
Message-ID: <61d756c7-caf1-4856-a384-703946f3d503@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

>Michal Marek <mmarek@suse.cz> wrote:
>
>> This option allows to append an externally computed singature to the
>> module. This is needed in setups, where the private key is not
>directly
>> available, but a service exists that returns signatures for given
>files.
>> 
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>> ---
>> v2: Use two-argument version of getopts to avoid global variables
>>     Use parentheses in EXPR if (...) constructs
>
>Feel free to add:
>
>Acked-by: David Howells <dhowells@redhat.com>
>
>to your patches.

Thanks for your review.

Michal

