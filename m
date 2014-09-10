Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbaIJEhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:37:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63786 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaIJEhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <1410202114.12560.16.camel@joe-AO725>
References: <20140908181524.GA11839@www.outflux.net>
	<1410202114.12560.16.camel@joe-AO725>
Date: Wed, 10 Sep 2014 13:37:22 +0900
Message-ID: <CALLJCT3syNafyj-y+1osLCMabszJbyZhmmKWLO8k8-y4Nkmpzg@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Masanari Iida <standby24x7@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe, Kees,

Sorry for late reply.
I was on holiday when the version 1 patch discussions were posted.

I am using codespell ( https://github.com/lucasdemarchi/codespell/ ).
The codespell has its own typo dictionary.
The dictionary format is

typo->good   (1 candidate)
typo->good1,good2,  (multiple candidates)
typo->good, comment  (1 candidate with special remark)

Its similar to your  typo||good  format.

The license of the codespell is GPLv2 according to COPYING file in tar ball.

Compare number of typo samples in dictionary.
Your dictionary :  1033
codespell-1.4 :     4261
codespell-1.4 + my adding 5245
Your dictionary + codespell-1.4 + my adding - remove duplicate:  5742

Latest version of codespell is 1.7.
My dictionary is based on codespell-1.4. So I use the number as of 1.4.

I can provide my typo samples under GPLv2 license.

Masanari
