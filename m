Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3CMDRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:17:31 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:39557 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab3CMDRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=lVDbKMmWS3x4oohb3dH78V0txoyfUcM9
	PWiUGmyhPmeG0Bc3wkYw7ndTTmj8glknR2Pwfa2+ei99tpgpbnwUJmlSUumXwGHZ
	SnvJmWExEHjoEta73ac/Fk+1/2P5CFFZC8vjaO5z8l1j0VWqPo/9d9YGq+79azDX
	JmtWBPQyjIg=
From: Junio C Hamano <gitster@pobox.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: linux-next: unneeded merge in the security tree
References: <7vtxog5msj.fsf@alter.siamese.dyndns.org>
 <20130313023026.GD16919@thunk.org>
Date: Tue, 12 Mar 2013 20:17:27 -0700
In-Reply-To: <20130313023026.GD16919@thunk.org> (Theodore Ts'o's message of
 "Tue, 12 Mar 2013 22:30:26 -0400")
Message-ID: <7v38w056pk.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 892E8DF0-8B8C-11E2-94E0-26A52E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:

> On Tue, Mar 12, 2013 at 02:30:04PM -0700, Junio C Hamano wrote:
>> Theodore Ts'o <tytso@mit.edu> writes:
>> 
>> > [remote "origin"]
>> > 	url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>> > 	fetch = +refs/heads/master:refs/heads/master
>> > 	mergeoptions = --ff-only
>> >
>> 
>> Is there an escape hatch for that rare case?  IOW, how does a
>> submaintainer who configured the above to override --ff-only?
>
> Hmm, maybe we would need to add a --no-ff-only?  Or they could just
> do:
>
> 	git fetch origin
> 	git merge FETCH_HEAD

Hmm, neither feel quite nice.

I haven't heard any comments on my alternative proposal, by the
way.  Did the message get lost?
