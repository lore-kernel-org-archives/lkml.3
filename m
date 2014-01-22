Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaAVSKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:10:30 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:33804 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaAVSK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=jnF5sP
	4itRC9xHjE1qXMJweEG38MZzN25bS7s7kGQrKXyKiZCZxvJ5GXpdE8LyjvbFukHO
	IUaQP+zcaYQkT1+L0qNQH4KvQ/BnVouUkG786RCgVuRk6Vv0UTlO8qjJVZqw8yBu
	GietZhoj297Svn1cyTa/gMpBzw2MIBNWYmZvc=
From: Junio C Hamano <gitster@pobox.com>
To: Vicent =?utf-8?Q?Mart=C3=AD?= <tanoku@gmail.com>
Cc: Stefan =?utf-8?Q?N=C3=A4we?= <stefan.naewe@atlas-elektronik.com>,
        Javier Domingo Cansino <javierdo1@gmail.com>,
        "git\@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.9-rc0
References: <xmqq61pjzljn.fsf@gitster.dls.corp.google.com>
	<xmqqha8xt22p.fsf@gitster.dls.corp.google.com>
	<CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
	<52DFE882.2040605@atlas-elektronik.com>
	<xmqq7g9syp1m.fsf@gitster.dls.corp.google.com>
	<CAFFjANTNLnc4GcVeSEvuWpfYVXJchJqkHwvUVdREdXmWx6e4=Q@mail.gmail.com>
Date: Wed, 22 Jan 2014 10:10:18 -0800
In-Reply-To: <CAFFjANTNLnc4GcVeSEvuWpfYVXJchJqkHwvUVdREdXmWx6e4=Q@mail.gmail.com>
	("Vicent =?utf-8?Q?Mart=C3=AD=22's?= message of "Wed, 22 Jan 2014 18:26:23
 +0100")
Message-ID: <xmqqlhy7yjjp.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 750812D6-8390-11E3-B8BB-1B26802839F8-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vicent Martí <tanoku@gmail.com> writes:

>> Do these consume CPU every time somebody asks for a tarball?  That
>> might be considered "wrong" depending on the view.
>
> No, our infrastructure caches frequently requested tarballs so they
> don't have to be regenerated on the fly.

Thanks.  That is certainly good enough for consumers, and better
than having to manually create and upload for me ;-)
