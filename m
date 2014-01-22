Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaAVQLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:11:40 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:55264 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaAVQLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=yOQ4Xy
	g+OeZQd/QaanEJvPPDkN9wEqwaUOWXsTwL+QRrKkvLVeXF8SrLTJUoJX145cArjY
	yAJ/rzf671xBIcjeX1hAoXA1Zq9KMw8hLBMqy2Nu5v04pd2YeZ9iyS+XYOAYZQEN
	VPv848nRBGcQz/JyfA6xPszYNinmrz3TzI9pM=
From: Junio C Hamano <gitster@pobox.com>
To: Stefan =?utf-8?Q?N=C3=A4we?= <stefan.naewe@atlas-elektronik.com>
Cc: Javier Domingo Cansino <javierdo1@gmail.com>,
        "git\@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.9-rc0
References: <xmqq61pjzljn.fsf@gitster.dls.corp.google.com>
	<xmqqha8xt22p.fsf@gitster.dls.corp.google.com>
	<CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
	<52DFE882.2040605@atlas-elektronik.com>
Date: Wed, 22 Jan 2014 08:11:33 -0800
In-Reply-To: <52DFE882.2040605@atlas-elektronik.com> ("Stefan =?utf-8?Q?N?=
 =?utf-8?Q?=C3=A4we=22's?= message
	of "Wed, 22 Jan 2014 16:49:22 +0100")
Message-ID: <xmqq7g9syp1m.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: DDECA5A2-837F-11E3-95CA-1B26802839F8-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Näwe <stefan.naewe@atlas-elektronik.com> writes:

> Am 22.01.2014 13:53, schrieb Javier Domingo Cansino:
>> Will there be any change on how tarballs are distributed, taking into
>> account that Google will be shutting down Google Code Downloads
>> section[1][2]?
>> 
>
> Am I missing something or what's wrong with this:
>
>   https://github.com/gitster/git/archive/v1.9-rc0.tar.gz
>
> or any
>
>   https://github.com/gitster/git/archive/$TAG.tar.gz
>
> ??

Do these consume CPU every time somebody asks for a tarball?  That
might be considered "wrong" depending on the view.
