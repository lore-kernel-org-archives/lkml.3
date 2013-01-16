Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab3APMsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:48:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab3APMsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:48:12 -0500
Message-ID: <50F6A187.7010101@suse.cz>
Date: Wed, 16 Jan 2013 13:48:07 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Dmitry Voytik <dvv.kernel@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 1/2] nconf:  add keybindings for vi-style menu navigation,
 rewrite help texts
References: <20121228185108.GA13644@voyt-hp> <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com> <20121229223415.GB28355@mobil.systemanalysen.net> <201301141924.37268.yann.morin.1998@free.fr> <20130115161031.GA5513@mobil.systemanalysen.net> <20130115162632.GB5513@mobil.systemanalysen.net>
In-Reply-To: <20130115162632.GB5513@mobil.systemanalysen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.1.2013 17:26, Roland Eggner wrote:
>> From: Roland Eggner <edvx1@systemanalysen.net>
> 
> •  Implemented vi-style navigation <k> <j> <l> <h>, based on initial work by
>    Dmitry Voytik.  Using <?> <H> instead of <?> <h> for help related to current
>    menu entry avoids conflict.

It conflicts with previous behavior that people got used to, though.

Also, please split the patch at least into one part adding the new key
binding and a second part rewriting the help texts.

Michal
