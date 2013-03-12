Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab3CLUns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:43:48 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:40519 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab3CLUnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=u+vImh0RvxBX/yPUu2shAcm2ewyFjY1X
	eQvMJxuPx2gbmRHHY7TUCcVW9ullzaARmtMJdYFguLzGS7QMzg56FtqjCB/enVx5
	Bofdc1/VlQvxUXvkP/yRX0r0WMKiVKnnN4Sy7ML39nG5bXmqRx+Fgi30sSJFGblj
	uHLqhs2fPK4=
From: Junio C Hamano <gitster@pobox.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: unneeded merge in the security tree
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
 <alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
 <20130312041641.GE18595@thunk.org>
 <20130312161823.86ea101fc4e45285b205817f@canb.auug.org.au>
Date: Tue, 12 Mar 2013 13:43:44 -0700
In-Reply-To: <20130312161823.86ea101fc4e45285b205817f@canb.auug.org.au>
 (Stephen Rothwell's message of "Tue, 12 Mar 2013 16:18:23 +1100")
Message-ID: <7vboao73i7.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 88CC38D0-8B55-11E2-80F0-26A52E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> I wonder if "git merge v3.9-rc2^{}" should work.

With less typing, "git merge v3.9-rc2^0", is the more traditional
way, but "git merge v3.9-rc2^{}" should also work.


