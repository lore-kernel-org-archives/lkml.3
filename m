Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaFQFq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:46:59 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:55253 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaFQFq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:46:58 -0400
Date: Tue, 17 Jun 2014 07:46:54 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>
Subject: Re: [Nouveau] REGRESSION: Kernel PANIC
 8777c5c11764d8336d8270f96778158c34c92108 - drm/nouveau/dp: probe dpcd to
 determine connectedness
Message-ID: <20140617054654.GB9117@glanzmann.de>
Mail-Followup-To: Ben Skeggs <skeggsb@gmail.com>,
	Ben Skeggs <bskeggs@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	nouveau <nouveau@lists.freedesktop.org>
References: <20140613095820.GA21162@glanzmann.de>
 <CACAvsv5dVMKcF67SO1qT=Foh4F0DkHeWNUztf8sQf++8GF-eMw@mail.gmail.com>
 <20140617053332.GA9117@glanzmann.de>
 <CACAvsv6nyu4cw6Yc1r5L8XNbS_Dyrka7o1JH=2Kc6URUWVcxjA@mail.gmail.com>
 <CACAvsv7WVPVE_axXU9MS07DVRsn9DaZ+NF5A+9yYr5XxKWYe3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAvsv7WVPVE_axXU9MS07DVRsn9DaZ+NF5A+9yYr5XxKWYe3A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben,

> > 8777c5c11764d8336d8270f96778158c34c92108 (which is mentioned as the
> > first bad commit above...) is a tiny commit, so I have no idea what
> > you mean by "too large for your taste".

for example I would not export a symbol and do something else in the
same commit, but would split them up in two. I do the minimum work per
commit without breaking compilation or functionality. That way it is
easier to identify issues later on.

> In any case, I encountered the oops myself earlier (absolutely nothing
> to do with that commit) and fixed it here.  I've sent it onto Dave for
> the next -fixes merge, so hopefully it'll help your case too.

Can you please send me your fix. I can reboot my machine remotely, but
only once. That way I can tell you if your fix works, or not.

> I have no idea why gmail doesn't auto-add you to the Cc list on reply
> all.. But.. Done :)

thanks.

Cheers,
        Thomas
