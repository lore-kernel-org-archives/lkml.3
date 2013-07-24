Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3GXKBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:01:30 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64830 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3GXKB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130724102123.6d1156925959e56640c23468@canb.auug.org.au>
References: <20130723095513.19b9638ab4a19157e9834dcf@canb.auug.org.au>
 <CACxGe6tjrFG1aLc9Scmmuunjb9hTm5vyH6LqXiys8484YY=Zzw@mail.gmail.com> <20130724102123.6d1156925959e56640c23468@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 24 Jul 2013 11:01:07 +0100
X-Google-Sender-Auth: PpISzb77tZlqAe9f3xMEO1vRBr4
Message-ID: <CACxGe6uB5wKzaM_X3ROnD0z+wc7WZ=cHF1bm3zD=mm=mb5QJxg@mail.gmail.com>
Subject: Re: linux-next: status of various trees
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 1:21 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> OK, I have done all that.  I also removed the irqdomain-current and
> spi-current trees.
>
> So the trees I have left that you are responsible for are:
>
> devicetree-current      git://git.secretlab.ca/git/linux-2.6#devicetree/merge
> devicetree              git://git.secretlab.ca/git/linux-2.6#devicetree/next
> arm-dt                  git://git.secretlab.ca/git/linux-2.6#devicetree/arm-next

You can drop the arm-dt tree also.

Thanks,
g.
