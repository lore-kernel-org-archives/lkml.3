Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbbAMVFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:05:16 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54779 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbbAMVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:05:14 -0500
Message-ID: <1421183111.15397.34.camel@x220>
Subject: Re: [PATCH] headers_check: don't warn about kexec.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maximilian Attems <max@stro.at>, Geoff Levand <geoff@infradead.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Tue, 13 Jan 2015 22:05:11 +0100
In-Reply-To: <2363197.VbAKlSiQLX@wuerfel>
References: <12825174.7oxZXDxNhV@wuerfel> <1421169212.15397.22.camel@x220>
	 <2363197.VbAKlSiQLX@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2015 21:05:11.0608 (UTC) FILETIME=[9E86A380:01D02F74]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dragging Andrew, Linus, and Maximilian into this thread.]

On Tue, 2015-01-13 at 21:27 +0100, Arnd Bergmann wrote:
> On Tuesday 13 January 2015 18:13:32 Paul Bolle wrote:
> > The last time that Geoff has been trying to get that patch applied
> > should be
> > http://lkml.kernel.org/r/b0702fc4186db21820d686e89afd6480560823db.1415837218.git.geoff@infradead.org> 
> > I'd rather see that go in.
> 
> Fine with me as well. As long as we can find someone to take one of 
> the patches, I'm happy.

Since Geoff's patch (and my preceding, identical patch) basically is a
partial revert of commit 29a5c67e7a78 ("kexec: export kexec.h to user
space") that should probably be done by either Andrew or Linus. 

(This short thread starts at
http://lkml.kernel.org/r/12825174.7oxZXDxNhV@wuerfel .)


Paul Bolle

