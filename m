Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbbA0PfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:35:13 -0500
Received: from plane.gmane.org ([80.91.229.3]:33246 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbA0PfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:35:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andreas Gruenbacher <agruen@gnu.org>
Subject: Re: patch-2.7.3 no longer applies relative symbolic link patches
Date: Tue, 27 Jan 2015 15:26:01 +0000 (UTC)
Message-ID: <ma8am9$t01$1@ger.gmane.org>
References: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
	<CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
	<CA+55aFxbY21vBbPs5qCFPT1HSBbaeS+Z2Fr9So1r3rXrMWe_ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 80-110-112-196.cgn.dynamic.surfer.at
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: git@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 12:44:33 -0800, Linus Torvalds wrote:
> I've considered that for a while already, because "patch" _does_ kind of
> understand them these days, although I think it gets the cross-rename
> case wrong because it fundamentally works on a file-by-file basis.

Patch handles cross-renames correctly nowadays; if not, it's a bug.

That's not enough to solve the symlink problem unfortunately.

Andreas

