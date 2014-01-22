Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaAVR0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:26:46 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:37562 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaAVR0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <xmqq7g9syp1m.fsf@gitster.dls.corp.google.com>
References: <xmqq61pjzljn.fsf@gitster.dls.corp.google.com> <xmqqha8xt22p.fsf@gitster.dls.corp.google.com>
 <CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
 <52DFE882.2040605@atlas-elektronik.com> <xmqq7g9syp1m.fsf@gitster.dls.corp.google.com>
From: =?UTF-8?Q?Vicent_Mart=C3=AD?= <tanoku@gmail.com>
Date: Wed, 22 Jan 2014 18:26:23 +0100
Message-ID: <CAFFjANTNLnc4GcVeSEvuWpfYVXJchJqkHwvUVdREdXmWx6e4=Q@mail.gmail.com>
Subject: Re: [ANNOUNCE] Git v1.9-rc0
To: Junio C Hamano <gitster@pobox.com>
Cc: =?UTF-8?B?U3RlZmFuIE7DpHdl?= <stefan.naewe@atlas-elektronik.com>,
        Javier Domingo Cansino <javierdo1@gmail.com>,
        "git@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 5:11 PM, Junio C Hamano <gitster@pobox.com> wrote:
> Stefan Näwe <stefan.naewe@atlas-elektronik.com> writes:
>
>> Am 22.01.2014 13:53, schrieb Javier Domingo Cansino:
>>> Will there be any change on how tarballs are distributed, taking into
>>> account that Google will be shutting down Google Code Downloads
>>> section[1][2]?
>>>
>>
>> Am I missing something or what's wrong with this:
>>
>>   https://github.com/gitster/git/archive/v1.9-rc0.tar.gz
>>
>> or any
>>
>>   https://github.com/gitster/git/archive/$TAG.tar.gz
>>
>> ??
>
> Do these consume CPU every time somebody asks for a tarball?  That
> might be considered "wrong" depending on the view.

No, our infrastructure caches frequently requested tarballs so they
don't have to be regenerated on the fly. If you would prefer to
distribute a different version of the tarball for the release (e.g.
one with a different filename or folder structure), you can upload it
directly to the release page of the tag:

    https://github.com/gitster/git/releases/tag/v1.9-rc0

We'll automatically mirror your release to S3 and serve it from there.
You can also go ahead and edit the release page with the changelog
you've posted in this email thread to make it more user friendly.

WE WILL SERVE YOUR RELEASES, JUNIO

BECAUSE WE LOVE YOU

-vmg
