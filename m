Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3BYHnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:43:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3BYHnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 02:43:49 -0500
Message-ID: <1361778224.4555.163.camel@marge.simpson.net>
Subject: Re: Fwd: Cpu hotplug causes stutter on AMD platform, how can I
 disable it?
From: Mike Galbraith <bitbucket@online.de>
To: Mario Giammarco <mgiammarco@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Feb 2013 08:43:44 +0100
In-Reply-To: <CABQ2P6FVZHWCUogV=xmxv8g-y7RWV_tQqxRMJyxTQK_ixnySjw@mail.gmail.com>
References: <CABQ2P6FJBSeuGjQbOEuek6QXkRzRbQMHvsApq4g2-0OGykjKZw@mail.gmail.com>
	 <CABQ2P6FVZHWCUogV=xmxv8g-y7RWV_tQqxRMJyxTQK_ixnySjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:EZ920Em23QpNbvijEG3sCXQ8l89XQ9JdnhccNGCBHEp
 lInoHM/86hh+x93mrOva9hnV48HGn9D/8hDVsV5m45h0Hlx54A
 kOrkoYPMsgpj832/qrCjKaPH0sQ/8sTlSuwnWYxon63QJxdEtH
 746PiN/cM4vmIA2JdlkfUEU0fYu0vCQx61AjYuDRl+SISrxp1g
 0GusAR6ZgRO+RJOzuCOj7eKm2IhfrLJNyLIBdB8YtFOIOk9mfq
 VUSw6FBUBq42jH7fi5kh4k/Iu9/KB6Aab6qqNFaHHWzKymmgbT
 Mo5YtBsprpHs6OqEFCfxc/rlHPiHQGZE7HSxcjV5FlzFvQ+lvQ
 WLIIFKQ9YPtmdWLDLsQRDgiD7vWkyPmrWTAD4PE1y2VqR7dbui
 ySj30Q3vs6n4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-24 at 22:59 +0100, Mario Giammarco wrote:

> I have searched on internet and I see that is a problem common to
> several AMD platforms.
> Even in Microsoft Windows several people have the same problem and
> they solved it disabling cool&quiet on bios. It seems that some amd
> cpus on power saving cut off also HT bus blocking data from pcie bus
> (!?!)
> I have tried too and infact disabling cool&quiet improves a lot the problem.
> But I would like to find a better solution, can I disable cpu hotplug?
> Have you heard of this bug before?

I haven't, but likely others have.  Hm.. if BIOS is shutting down your
CPUs, I suspect that trying to ignore that in the kernel would be the
mother of all bad ideas :)

-Mike

