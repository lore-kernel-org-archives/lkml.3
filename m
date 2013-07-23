Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab3GWR3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:29:25 -0400
Received: from fep22.mx.upcmail.net ([62.179.121.42]:36179 "EHLO
	fep22.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3GWR3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:29:24 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
User-Agent: K-9 Mail for Android
In-Reply-To: <20974.46422.436937.172719@pilspetsen.it.uu.se>
References: <51EEA665.2050209@odi.ch> <20974.46422.436937.172719@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: CONFIG_X86_PKG_TEMP_THERMAL causes #GP fault on Core i7-740QM breaking boot
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
Date: Tue, 23 Jul 2013 19:29:18 +0200
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org
Message-ID: <b89aaa4f-d062-4fbc-a456-f9447c73de27@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mikael Pettersson <mikpe@it.uu.se> >I can see that patch in git, it's NOT present in
>either
>the linux-3.11-rc2.tar.xz or the patch-3.11-rc2.xz files.  Which is
>strange
>since the patch was committed 8 days ago, and -rc2 was released 2 days
>ago.

It was merged only after rc2. Only in the tree that it was merged from it was commited before rc2. See 
gitk v3.11-rc2..

Ortwin
