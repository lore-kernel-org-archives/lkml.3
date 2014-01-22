Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaAVPzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:55:20 -0500
Received: from mail96.atlas.de ([194.156.172.86]:34888 "EHLO mail96.atlas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbaAVPzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:55:17 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2014 10:55:17 EST
Message-ID: <52DFE882.2040605@atlas-elektronik.com>
Date: Wed, 22 Jan 2014 16:49:22 +0100
From: =?UTF-8?B?U3RlZmFuIE7DpHdl?= <stefan.naewe@atlas-elektronik.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Javier Domingo Cansino <javierdo1@gmail.com>,
        Junio C Hamano <gitster@pobox.com>
Cc: "git@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.9-rc0
References: <xmqq61pjzljn.fsf@gitster.dls.corp.google.com> <xmqqha8xt22p.fsf@gitster.dls.corp.google.com> <CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
In-Reply-To: <CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.01.2014 13:53, schrieb Javier Domingo Cansino:
> Will there be any change on how tarballs are distributed, taking into
> account that Google will be shutting down Google Code Downloads
> section[1][2]?
> 

Am I missing something or what's wrong with this:

  https://github.com/gitster/git/archive/v1.9-rc0.tar.gz

or any

  https://github.com/gitster/git/archive/$TAG.tar.gz

??

(As long as Junio continues to push to github, of course)

Stefan
-- 
----------------------------------------------------------------
/dev/random says: Folks who think they know it all bug those of us who do
python -c "print '73746566616e2e6e616577654061746c61732d656c656b74726f6e696b2e636f6d'.decode('hex')"
