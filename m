Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaK2Uij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 15:38:39 -0500
Received: from plane.gmane.org ([80.91.229.3]:51021 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaK2Uii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 15:38:38 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: frequent lockups in 3.18rc4
Date: Sat, 29 Nov 2014 18:38:18 -0200
Organization: http://www.youtube.com/DanielFragaBR
Message-ID: <m5dart$co$1@ger.gmane.org>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141126002501.GA11752@redhat.com>
	<CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
	<20141126024032.GA13246@redhat.com>
	<20141126225745.GA30346@redhat.com>
	<CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 177.102.84.214
X-Newsreader: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 17:56:37 -0500
Dave Jones <davej@redhat.com> wrote:

> Agreed.
> 
> Currently leaving 3.16 running. 21hrs so far.

	Dave, I think I reported this bug in this bug report:

https://bugzilla.kernel.org/show_bug.cgi?id=85941

	Just posting in case the call trace helps...

	In my case it happens when I watch a video on Youtube or play a
audio file...

-- 
Linux 3.16.0-00115-g19583ca: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL


