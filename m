Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaHLRML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:12:11 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33308 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaHLRMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:12:09 -0400
MIME-Version: 1.0
Date: Tue, 12 Aug 2014 10:12:07 -0700
Message-ID: <CA+r1Zhip1SZww=sueoRJD=ZzekqLJjeY7O461wnFVRdsuz+eWg@mail.gmail.com>
Subject: make mandocs error with next-20140812
From: Jim Davis <jim.epost@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

docproc: .//drivers/gpu/drm/drm_stub.c: No such file or directory
make[1]: *** [Documentation/DocBook/drm.xml] Error 1
make: *** [mandocs] Error 2
