Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3JMBTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 21:19:22 -0400
Received: from nm17-vm6.access.bullet.mail.gq1.yahoo.com ([216.39.63.165]:20648
	"EHLO nm17-vm6.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922Ab3JMBTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 21:19:20 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Oct 2013 21:19:20 EDT
X-Yahoo-Newman-Id: 666406.30700.bm@smtp118.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z1RzX.sVM1liRin4RoXEoxhFZAxd2uShw9EpCaZZ4nuxdYT
 34FmQhb96iT25npI.P8hYZGhI3IkUQDvFlRObPCcicbh_bTi8f9rxvAGNy_Q
 R76iIxUMu9m4zKzpkwBiWgJUJtmHvip3Jh89d3P2I3_uqHRRECUKWMH6y7Zm
 gNZOQH8a589muClXouCHl7P9tU.Cuu45VHHYK45d2J3rHDKkxWDmOnhDd4Tf
 Y5yNp80sfVM9RicCehy5DcX0t8Aj8PHUGJ42dOuVamM7Wlsx6MyI9eJSVAJ_
 K0iwzkcZW6RglSbVbILsSuoT5wDcIPEjkkeAo_NBSh.qdfeoXs6C9fB6RNmT
 szoh3Pezwa9otWFWYcwyUlqqKCpFnsJbDuBcGbO8zlP79ZCyqlboaxd4.oMg
 EYHID3XZmfnufQ34S4e2JA4RU9.KbDQKrVvnBAjVcCLJ1zEGc7YxjbwHrT2P
 vQqoIkgRYENxy412tQNxdusyq_J6m1x_1yy7Cg8xkSADHnK4e4M5xQVXZluf
 nBgE3CCewp9b.THRadYzpU79BGOy6dumd6TATRN.RGHdYwtRbrgRxX0.OU58
 I13gwu4BMIi58r4ZuQFs6Uaf3zZ8tiGO3lp5vq3SBC7wU43XWkVQhNRgEDIY
 8O8NXEofgQBeD
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-Rocket-Received: from segfault.sh0n.net (shawn.starr@174.112.94.49 with )
        by smtp118.sbc.mail.gq1.yahoo.com with SMTP; 13 Oct 2013 01:12:34 +0000 UTC
From: Shawn Starr <shawn.starr@rogers.com>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No longer able to build kernel into RPM on Fedora
Date: Sat, 12 Oct 2013 21:12:30 -0400
Message-ID: <1934042.ubj0gKsRvQ@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.11.2 (Linux/3.12.0-rc4+; KDE/4.11.2; x86_64; ; )
In-Reply-To: <5259EABD.3060304@spin.net.au>
References: <2492370.jKSlzuQ6pe@segfault.sh0n.net> <5259EABD.3060304@spin.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 13, 2013 10:35:09 AM Chris Jones wrote:
> As a temporary work around, can you revert to the older version of RPM?
> 

Hi Chris,

I was missing rpm-build, I have a patch submitted to force use of rpm-build. 
AFAIK, nobody uses legacy rpm anymore since falling back to just rpm will fail 
since it does not have --target or -ta options.

Thanks,
Shawn

> 
> Regards
> 
> On 10/13/2013 05:03 AM, Shawn Starr wrote:
> > Hello folks,
> > 
> > My usual approach to testing git snapshots of Linus's tree (with custom
> > patches applied on top) is to make rpm and install this into my system for
> > a clean add/remove of test kernels.
> > 
> > However,  the developers of rpm removed the --target and -ta options, so I
> > can't take tarball and build into RPM anymore.
> > 
> > Since I last built custom RPM builds of Linus's tree was likely Fedora 18,
> > it seems the option target got removed by 19.
> > 
> > Any ideas, fixes?
> > 
> > Thanks,
> > Shawn
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

