Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3J2Lyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:54:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34572 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3J2Lyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:54:33 -0400
X-Spam-Score: -100.8
Message-ID: <526FA1B7.4090808@asianux.com>
Date: Tue, 29 Oct 2013 19:53:27 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Vineet Gupta <vineetg76@gmail.com>, James Hogan <james.hogan@imgtec.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] arch: use ASM_NL instead of ';' for assembler new line
 character in the macro
References: <526F09B8.9030202@asianux.com> <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <24899.1383043169@warthog.procyon.org.uk>
In-Reply-To: <24899.1383043169@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 06:39 PM, David Howells wrote:
> Chen Gang <gang.chen@asianux.com> wrote:
> 
>>> > > And you also need to fix kernel/modsign_certificate.S as part of same patchset as
>>> > > that is where the problem started in first place.
>>> > > 
>> > 
>> > Hmm... can that be another patch?
>> > 
>> > For "kernel/modsign_certificate.S", I recommend to expand the macro
>> > which will shrink code line, either need not include additional header
>> > file, I feel that will be simpler for both code reader and writers.
> I recommend leaving that file alone.  That gets moved to a .S file in patches
> queued in the security tree.

Excuse me, I am not quite familiar with our version merging, I guess
your meaning is "this file will be removed, and the related contents
will be in another .S file, so we need not fix it within this file".

If what I guess is correct, I support your recommendation (and if what I
guess is incorrect, please let me know, thanks). :-)

BTW: I still use next-20130927 tree for it, and another next-tree branch
which is next-20131025 do not have this file.


Thanks.
-- 
Chen Gang
