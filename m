Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbaAVPmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:42:22 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:59734 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbaAVPmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:42:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=p/nLHAFa5HavCXucX21tYqSgzsQYiRCt
	QmNVyNnQsXJtDl+7DppRs2xt0UhiKNwrq2COvFgG4meFukwF/+Hk/tGxPxsnl3oD
	1u4LofecasG8Z4FjE23l8tSqHHVWPRdtJqa81MmDSQj+DWpO3H/ZolkHkqd1tgmK
	sBmRKsVj/yo=
From: Junio C Hamano <gitster@pobox.com>
To: Javier Domingo Cansino <javierdo1@gmail.com>
Cc: "git\@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.9-rc0
References: <xmqq61pjzljn.fsf@gitster.dls.corp.google.com>
	<xmqqha8xt22p.fsf@gitster.dls.corp.google.com>
	<CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
Date: Wed, 22 Jan 2014 07:42:12 -0800
In-Reply-To: <CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
	(Javier Domingo Cansino's message of "Wed, 22 Jan 2014 13:53:26
	+0100")
Message-ID: <xmqqk3dsyqej.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: C429E156-837B-11E3-B748-1B26802839F8-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Domingo Cansino <javierdo1@gmail.com> writes:

> Will there be any change on how tarballs are distributed, taking into
> account that Google will be shutting down Google Code Downloads
> section[1][2]?

Aside from the obvious "we won't be able to use something that is no
longer offered"?  They are not the only download site even now, so...
