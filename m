Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030387AbaGROym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:54:42 -0400
Received: from isis.lip6.fr ([132.227.60.2]:56428 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761797AbaGROyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:54:40 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2014 10:54:39 EDT
X-pt: isis.lip6.fr
Date: Fri, 18 Jul 2014 16:46:21 +0200
From: Benoit Taine <benoit.taine@lip6.fr>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: kernelnewbies@kernelnewbies.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: How to automate checkpatch && get_maintainers && git send-email
 of commits range?
Message-ID: <20140718144621.GA12871@lip6.fr>
References: <CANZNk81LiTM9vY0dRV=T0BCT9k-BxU45Ojw_PyOcpdmtXHKM2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANZNk81LiTM9vY0dRV=T0BCT9k-BxU45Ojw_PyOcpdmtXHKM2Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 16:45:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/2014 17:38, Andrey Utkin wrote:
> Is there script for automated checkpatch.pl && get_maintainers.pl &&
> git send-email for range of commits? I see none. Would it be welcome
> to submit such one to kernel tree?

You can use `splitpatch` to split a patch into multiple mails with the
correct mailing list and maintainers. It generates a script to
chain-send these emails using `cocci-send-email` (a modified version of
`git-send-email`).

Both are available in the `tools/` directory of coccinelle's
distribution <http://coccinelle.lip6.fr/>.

-- 
Benoît Taine
Master cycle intern
Regal Team. LIP6
