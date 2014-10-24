Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaJXIkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:40:13 -0400
Received: from static.162.253.133.43.macminivault.com ([162.253.133.43]:57336
	"EHLO mwork.nabble.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbaJXIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:40:11 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2014 04:40:11 EDT
Date: Fri, 24 Oct 2014 01:31:46 -0700 (MST)
From: "y.gribov" <y.gribov@samsung.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1414139506040-968477.post@n7.nabble.com>
In-Reply-To: <5446135E.9020101@samsung.com>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com> <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com> <5445640F.10000@oracle.com> <5446135E.9020101@samsung.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unaligned accesses disabled because they are allowed on some arches (see
HAVE_EFFICIENT_UNALIGNED_ACCESS).
> Another reason is that there are to many reports. Not because there are
> lot of bugs, but because
> there are many reports for one bug. 

A side note - unaligned accesses would prevent KASan from doing it's job
well because instrumentation code relies on address alignment when
performing the check.

-Y



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/RFC-UBSan-run-time-undefined-behavior-sanity-checker-tp965203p968477.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
