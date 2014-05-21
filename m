Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaEUVss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:48:48 -0400
Received: from smtp.pobox.com ([208.72.237.35]:50172 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbaEUVso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=dhbaEghc56An+33/ADguT79suAXvSj0v
	LLc/wjQJ2p15rodKih2NeruLfOZ6DdXBMuF1r6wNfSFSLeVApTczFxHK7R3dPl1Z
	c8pEHwCHYt9lg9uZnZTNHgy1QMRIFqq1RHj2D3A3CG54xA9SCa8sR14BVsA6Psx0
	H1MuyHqb87I=
From: Junio C Hamano <gitster@pobox.com>
To: Richard Hansen <rhansen@bbn.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v2.0.0-rc4
References: <xmqqr43oq8q5.fsf@gitster.dls.corp.google.com>
	<537D1B05.6030209@bbn.com>
Date: Wed, 21 May 2014 14:48:38 -0700
In-Reply-To: <537D1B05.6030209@bbn.com> (Richard Hansen's message of "Wed, 21
	May 2014 17:30:45 -0400")
Message-ID: <xmqqsio2olah.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: ABF0B9C0-E131-11E3-9157-9903E9FBB39C-77302942!pb-smtp0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Hansen <rhansen@bbn.com> writes:

>>  * The shell prompt script (in contrib/), when using the PROMPT_COMMAND
>>    interface, used an unsafe construct when showing the branch name in
>>    $PS1.
>>    (merge 8976500 rh/prompt-pcmode-avoid-eval-on-refname later to maint).
>
> That commit has been merged to maint and is in v1.9.3.
>
> Also, 1e4119c (git-prompt.sh: don't assume the shell expands the value
> of PS1) is a fix that is in v2.0.0-rc4 but not v1.9.x.  Maybe add
> something like:
>
>  * The shell prompt script (in contrib/), when using Zsh and the
>    precmd() interface, printed ${__git_ps1_branch_name} in the prompt
>    instead of the branch name (regression in v1.9.3).
>    (merge 1e4119c rh/prompt-pcmode-avoid-eval-on-refname later to
>    maint).

Yes, already done this morning but not yet ready to be pushed out.

Thanks.
