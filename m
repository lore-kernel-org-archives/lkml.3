Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3GHUai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:30:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56777 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab3GHUah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:30:37 -0400
Date: Mon, 8 Jul 2013 16:30:36 -0400
From: Mike Pagano <mpagano@gentoo.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Modification of the diffconfig script to support python
 3.x and 2.7
Message-ID: <20130708203036.GA30726@woodpecker.gentoo.org>
References: <10816010.V3ekNYfWHj@comanche>
 <15619.1373310883@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15619.1373310883@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 03:14:43PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 04 Jul 2013 20:19:03 -0400, Mike Pagano said:
> 
> I'm not a snake-language person, but...
> 
> > -    print """Usage: diffconfig [-h] [-m] [<config1> <config2>]
> > +    print ("""Usage: diffconfig [-h] [-m] [<config1> <config2>]
> 
> Is this hunk missing a ) at the end of the line?


No, there's a lot of lines in bewteen the first ( and the closing one
which is added in the patch:


-"""
+""")



-- 
Mike Pagano
Gentoo Developer - Kernel Project
Gentoo Sources - Lead 
E-Mail     : mpagano@gentoo.org
GnuPG FP   : EEE2 601D 0763 B60F 848C  9E14 3C33 C650 B576 E4E3
Public Key : http://pgp.mit.edu:11371/pks/lookup?search=0xB576E4E3&op=index
