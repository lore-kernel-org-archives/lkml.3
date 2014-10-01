Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaJAOjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:39:18 -0400
Received: from mx10.pku.edu.cn ([162.105.129.173]:59936 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751469AbaJAOjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:39:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.406
Date: Wed, 1 Oct 2014 22:38:59 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Message-ID: <1890664630.35241.1412174339749.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1411981207.6334.6.camel@x220>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_[PATCH]_unicore32:_Remove_u?=
 =?utf-8?Q?nneeded_Kconfig_entry_NO=5FIOPORT=5FMAP?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Paul Bolle <pebolle@tiscali.nl> 写道：
> On Sun, 2014-09-28 at 09:49 +0800, Xuetao Guan wrote:
> > Sorry for late reply.
> 
> You replied within four days. That's rather quick, actually.
> 
> > I checked this config, and it's only used for HAS_IOPORT_MAP in lib/Kconfig
> > Sure, removing it means no different for .config file.
> > I think a better way is reserving it
> 
> I'm not sure I get what you're saying here: what do mean with "reserving
> it"?

I mean, it's better to keep the code unchanged.

> 
> > or moving it into arch/Kconfig
> 
> Without a (treewide) patch I find it hard to say whether that's worth
> the trouble. But even if that move would be done, wouldn't it include
> dropping this entry from arch/unicore32 anyway?

IMHO, this config could be removed from kernel code.

> 
> 
> Paul Bolle
> 

