Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbaFQFdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:33:36 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:55234 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbaFQFde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:33:34 -0400
Date: Tue, 17 Jun 2014 07:33:32 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>
Subject: Re: [Nouveau] REGRESSION: Kernel PANIC
 8777c5c11764d8336d8270f96778158c34c92108 - drm/nouveau/dp: probe dpcd to
 determine connectedness
Message-ID: <20140617053332.GA9117@glanzmann.de>
Mail-Followup-To: Ben Skeggs <skeggsb@gmail.com>,
	Ben Skeggs <bskeggs@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	nouveau <nouveau@lists.freedesktop.org>
References: <20140613095820.GA21162@glanzmann.de>
 <CACAvsv5dVMKcF67SO1qT=Foh4F0DkHeWNUztf8sQf++8GF-eMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAvsv5dVMKcF67SO1qT=Foh4F0DkHeWNUztf8sQf++8GF-eMw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben,

> Are you able to double-check that bisect?  I'm not at all sure how
> that particular commit could trigger the issue you're seeing.  Some of
> the others, certainly.  It might be worth trying a couple of times
> before marking something as "good", in case there's a timing aspect to
> the problem.

please CC me, otherwise I might not see your message. The bug is very
clear, I boot my machine, the screen turns black as soon as the X server
is booted and the system does not ping anymore. I rebooted several times
before the bisect and the bug always hit me. For my taste the offending
commit is to large. So maybe I can split it in multiple smaller commits
and than debug it. However I'm currently out of the office, so maybe
tomorrow. If you do any progress on this, please CC me in order to avoid
duplicate effort.

Cheers,
        Thomas
