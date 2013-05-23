Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab3EWVr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 17:47:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629Ab3EWVrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 17:47:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH, RFC 19/22] staging/solo6x10: depend on CONFIG_FONTS
Date: Thu, 23 May 2013 23:47:46 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-20-git-send-email-arnd@arndb.de> <CAMuHMdWrVCndJ=Cre5LUgTSyQMxn_XkHUCFa2qCz-ETUO+T-ug@mail.gmail.com>
In-Reply-To: <CAMuHMdWrVCndJ=Cre5LUgTSyQMxn_XkHUCFa2qCz-ETUO+T-ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305232347.47080.arnd@arndb.de>
X-Provags-ID: V02:K0:CyTmAj8OqemYFXnrlkq4GVB/HIO2CGgCBoF5gWQEKi4
 ENu4c+YSHRkpiqeioNtik/qBJ4oSIwKJxpo2WNfzPMkU8XnVZH
 3ELoHjcHg9ncX+ke2zQUvqVbJp/PpcyrOIongmB+j68+MJiQ/0
 lDXFQjHATWUOlLlxtT+NJGF+A3nnr384djXFA3DZeyDuhhATZG
 EsNeLbcyV7PXJkJa7qF1bj3yCrlPkpF8g/PTBymQCNCAsDCoFf
 SuuDeiS6/9Xkp/6FN6cLaX+QA38i1cNzUuPetipGExwy+RutQ8
 pc4pME5hUdVHT+jwSIoaKePqUv7dxyTOUTsWsR3I8EawG5GZug
 jmsxZ1Ql3yx90RMc/598=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 May 2013, Geert Uytterhoeven wrote:
> Sorry for only noticing this now, but CONFIG_FONTS is not about font support.
> It's about allowing the user to override the default list of builtin fonts.
> I know it's a bad name, but changing this would break make oldconfig.
> Or is this allowed?
> 
> My fix for the solo6x10 build breakage is
> http://marc.info/?l=linux-kernel&amp;m=136861809223875

Right, that sounds like a better solution.

	Arnd
