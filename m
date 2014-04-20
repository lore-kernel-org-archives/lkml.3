Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaDTVNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 17:13:15 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:51408 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaDTVNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 17:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=b2tSFF3FKTnpO+MvhcoIxNI7bNqWmYNL
	MwAxv536+lClqYxuYHc8cMIV41WZJwV0uSItpkft0o/OWdyNOZ1Nmq8xhZuWAdcq
	TyPWb3W9BcccwgOxIgKkhiIcPyJnEklyu7Ekb7fE0SOp9HG6u3GcPUDousNPeiJS
	JvPxHN8ARUU=
From: Junio C Hamano <gitster@pobox.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v2.0.0-rc0
References: <xmqqk3ambf9k.fsf@gitster.dls.corp.google.com>
	<53541b1214393_1f08dd12ece5@nysa.notmuch>
Date: Sun, 20 Apr 2014 14:14:50 -0700
In-Reply-To: <53541b1214393_1f08dd12ece5@nysa.notmuch> (Felipe Contreras's
	message of "Sun, 20 Apr 2014 14:08:02 -0500")
Message-ID: <7vk3ajln3p.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 92B862E2-C8D0-11E3-9026-0731802839F8-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras <felipe.contreras@gmail.com> writes:

> Junio C Hamano wrote:
>>  * transport-helper, fast-import and fast-export have been updated to
>>    allow the ref mapping and ref deletion in a way similar to the
>>    natively supported transports.
>
> Have they?

Yikes, no.  This was me mischaracterizingg the merge at 90e6255a6d01
(Merge branch 'fc/transport-helper-fixes', 2014-03-18).  It was
about letting the transport respond to 'force', and not about ref
mapping, I think.

Thanks for spotting.

Will remove that section from the release notes in the meantime.  As
to the resurrection of the series, that will have to cook outside
'master' at least for the remainder of this cycle.
