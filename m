Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab3FWT3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 15:29:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54798 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849Ab3FWT3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 15:29:40 -0400
X-Sasl-enc: AnvHA0QBxybdyCtfWQ9qRthateVmu5+P6VCADQooVrA2 1372015779
Date: Sun, 23 Jun 2013 16:29:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: MTRR use in drivers
Message-ID: <20130623192936.GA28655@khazad-dum.debian.net>
References: <51C3DDFA.7050204@zytor.com>
 <51C69732.1010906@gmail.com>
 <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jun 2013, H. Peter Anvin wrote:
> Why do you care about performance when PAT is disabled?

It will regress already slow boxes.  We blacklist a LOT of P4s, PMs, etc and
nobody ever took the pain to track down which ones of those actually have
PAT+MTRR aliasing bugs.

These boxes have boards like the Radeon X300, which needs either PAT or MTRR
to not become unusable...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
