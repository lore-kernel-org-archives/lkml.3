Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaHZVzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:55:49 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:5119 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbaHZVzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:46 -0400
Date: Tue, 26 Aug 2014 23:55:35 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Valdis.Kletnieks@vt.edu
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH][input-led] Defer input led work to workqueue
Message-ID: <20140826215535.GA6581@kria>
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
 <3942.1409078958@turing-police.cc.vt.edu>
 <20140826200208.GA11247@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140826200208.GA11247@kria>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-26, 22:02:08 +0200, Sabrina Dubroca wrote:
> [...]
> 
> Tested-by: Sabrina Dubroca <sd@queasysnail.net>

Forgot to mention, this applies to both versions of the patch.


-- 
Sabrina
