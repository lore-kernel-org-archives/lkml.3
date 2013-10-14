Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3JNMfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:35:37 -0400
Received: from mout.gmx.net ([212.227.17.20]:50327 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab3JNMff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:35:35 -0400
MIME-Version: 1.0
Message-ID: <trinity-4f52e27f-75d8-4137-83d6-d242e529c3c9-1381754133846@3capp-gmx-bs48>
From: "Helge Deller" <deller@gmx.de>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Aw: Re: [GIT PULL] parisc updates for v3.12-rc5
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Oct 2013 14:35:33 +0200 (CEST)
Importance: normal
Sensitivity: Normal
In-Reply-To: <20131014112621.GA9705@infradead.org>
References: <20131013161130.GA19534@p100.box>,
 <20131014112621.GA9705@infradead.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:GJqUwy1bzfHifCoSepgB+MfMUKEBN7w4qhYVM+5lur/
 xDFeW1B/t8jG+HY1N4SKfR21BpBQ4uqRxwwnMo35Accz/oOJ3A
 BF6gJj/h/Mf58zchvJKWJMJR0yP+cVO03KDQNPEQWFCvCGc9Hf
 C44Mx1ysTG3bKqMbLKv4QdKq3mqP1aZKKTKXlCgYhfGQZ7+GUy
 tJa2hyUWFBUZSh0LA/0A0jm+Mnj0VZcBG3txDG5rCcp0KrtO3+
 rTNsElTAwQgNakootGA4po2G+WsOfQracColqha4prQ7aJo30Z BJQCus=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Geert Uytterhoeven (1):
> >       parisc: Export flush_cache_page() (needed by lustre)
> 
> This one shouldn't go in - Geert sent it a bit prematurely, as Lustre
> shouldn't use it just to reimplement core VM functionality (which it
> shouldn't use either, but that's a separate story).

Ok, it's my fault then.
I'll include a reverting patch in the next parisc pull request...

Thanks,
Helge
