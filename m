Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaFJOaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:30:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaFJOaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:30:14 -0400
Message-ID: <53971674.603@suse.cz>
Date: Tue, 10 Jun 2014 16:30:12 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz> <1399639944-20551-4-git-send-email-mmarek@suse.cz> <CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com> <538EEA3D.1080105@suse.cz> <538F1B41.3060904@suse.cz> <20140605155614.GA18376@sepie.suse.cz> <539625D1.2090905@infradead.org> <539631CC.9040002@suse.cz> <5396340B.6060804@infradead.org> <20140609223922.GA3409@pobox.suse.cz> <5396479F.6030809@infradead.org> <5396C98E.8050501@suse.cz> <5397119C.9080402@infradead.org>
In-Reply-To: <5397119C.9080402@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-10 16:09, Randy Dunlap wrote:
> I'm not using git, just tarballs.  I don't have an include/generated
> subdirectory at all in my source tree.
> 
> However, today's linux-next builds OK for me (both i386 and x86_64),
> so let's go with your patch.

OK, then let's hope this does not reoccur.

Michal
