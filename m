Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3B0Kii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:38:38 -0500
Received: from intranet.asianux.com ([58.214.24.6]:60367 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3B0Kig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:38:36 -0500
X-Spam-Score: -100.8
Message-ID: <512DE213.3050001@asianux.com>
Date: Wed, 27 Feb 2013 18:38:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: roger.pau@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel <xen-devel@lists.xen.org>, konrad.wilk@oracle.com,
        dgdegra@tycho.nsa.gov,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/xen-blkback: preq.dev is used without initialized
References: <512D90F2.9070200@asianux.com> <512DE6B302000078000C1631@nat28.tlf.novell.com>
In-Reply-To: <512DE6B302000078000C1631@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月27日 17:57, Jan Beulich 写道:
> You also could have mentioned that even before commit 
> 01c681d4c70d64cb72142a2823f27c4146a02e63 the value printed
> here was bogus, as it was the guest provided value from
> req->u.rw.handle rather than the actual device.

  pardon ?

  I guess what you said is :
    my patch seems ok, but the comments need improving.
    need add "additional info" in comments:
      "before commit 01c681d4c70d64cb72142a2823f27c4146a02e63
       the value printed here was bogus, as it was the guest
       provided value from req->u.rw.handle rather than the
       actual device".

  is it correct ?

  thanks.

-- 
Chen Gang

Asianux Corporation
