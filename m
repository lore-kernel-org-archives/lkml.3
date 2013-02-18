Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab3BRXJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:09:16 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:37212 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab3BRXJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:in-reply-to:references:date:message-id:mime-version
	:content-type; q=dns; s=sasl; b=yT55V2ZHwO8EhvwJUom/HFBBxXBs27ON
	9CjLoq1NNOeZdrayBnmosTsqlPqoESCR3mLYF9nM+VbZ6gPAwExioZBGPunpwbk6
	N+j5Gw7K9n/FTu6zWGp18qiZloYIr6gCBBbf2TfluKHHf4D/K/9McsVrCFTo49Ck
	r7QahefA0nY=
From: Junio C Hamano <gitster@pobox.com>
To: Matthieu Moy <Matthieu.Moy@grenoble-inp.fr>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.8.2-rc0
In-Reply-To: <vpq4nh9v5an.fsf@grenoble-inp.fr> (Matthieu Moy's message of
 "Mon, 18 Feb 2013 19:35:28 +0100")
References: <7vk3q6e94s.fsf@alter.siamese.dyndns.org>
 <vpq4nh9v5an.fsf@grenoble-inp.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Mon, 18 Feb 2013 15:09:11 -0800
Message-ID: <7vobfh8bjc.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 3641256C-7A20-11E2-9827-21622E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthieu Moy <Matthieu.Moy@grenoble-inp.fr> writes:

> Junio C Hamano <gitster@pobox.com> writes:
>
>> Git v1.8.2 Release Notes (draft)
>> ========================
>>
>> Backward compatibility notes
>> ----------------------------
>>
>> In the upcoming major release (tentatively called 1.8.2), we will
>> change the behavior of the "git push" command.
>>
>> When "git push [$there]" does not say what to push, we have used the
>> traditional "matching" semantics so far (all your branches were sent
>> to the remote as long as there already are branches of the same name
>> over there).  We will use the "simple" semantics
>
> I don't understand: wasn't this supposed to happen in Git 2.0? Did you
> mean "In the upcoming major release (tentatively called *2.0*)"?

Thanks.  I am not sure what I was thinking.  Perhaps when we started
this cycle we did want to merge the push-2.0-default-to-simple series

Will update.

> Also, you may want to mention the argumentless "git add -u" change too.
> It currently has an item below, but this is a future
> backward-incompatible change so it may deserve to appear in this section
> too.

Quite right.  Care to do the honors as the proposer to the new
direction?

