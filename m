Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaEURFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:05:22 -0400
Received: from smtp.pobox.com ([208.72.237.35]:63096 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbaEURFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=v0d2/OWLtacM8+l9elTQlCX8UQ3F0hYf
	gF3cFzu6laUHu3HqIFNV61MLUwDvfoCnhHKgZWIda/7znEYXsQnENsA7xRd29pZT
	02KIhLvj8M0nw3bnKiSzklyLMYurol86hDpue5cjqdiYkYXCNJks58blzDA3Z7vq
	q0uPH1nK71g=
From: Junio C Hamano <gitster@pobox.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v2.0.0-rc4
References: <xmqqr43oq8q5.fsf@gitster.dls.corp.google.com>
	<537bf50f27417_353e13c330846@nysa.notmuch>
Date: Wed, 21 May 2014 10:05:07 -0700
In-Reply-To: <537bf50f27417_353e13c330846@nysa.notmuch> (Felipe Contreras's
	message of "Tue, 20 May 2014 19:36:31 -0500")
Message-ID: <xmqqa9abqczg.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 1136993A-E10A-11E3-BF41-9903E9FBB39C-77302942!pb-smtp0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras <felipe.contreras@gmail.com> writes:

> Junio C Hamano wrote:
>
>>  * The remote-helper interface to fast-import/fast-export via the
>>    transport-helper has been tightened to avoid leaving the import
>>    marks file from a failed/crashed run, as such a file that is out-of-
>>    sync with reality confuses a later invocation of itself.
>
> Really? Where are the patches for that?
>
> I think it's fair to say the way the remote-helpers and transport-helper
> has been handled for v2.0 has been a total disaster.

Thanks for noticing.  The last-minute change of plans in the morning
on the -rc release day did not help.  Will remove.

Anything else I missed?


