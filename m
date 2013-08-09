Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337Ab3HIO6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:58:21 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:44857 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab3HIO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:58:17 -0400
Message-ID: <52050382.9060802@gmail.com>
Date: Fri, 09 Aug 2013 16:58:10 +0200
From: Ben Tebulin <tebulin@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Reproducible git-fsck/SHA1 failures since 3.7.x on a Dell E6430 /
 i5-3340M
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel list!

On two machines a very specific repository the SHA1 implementation of
git-fsck and git-show fails in 9/10 cases for a specific 39MB blob.

This only occurs on vanilla Linux kernels 3.7.10, 3.8.0 (Ubuntu),
3.9.11, 3.10.5 _but not on_ 3.6.11 and 3.5.7

For details please refer to the thread starting at:
 http://article.gmane.org/gmane.comp.version-control.git/231872


Never had any other hardware/stability issues _at all_ with these
machines. Only one repo out of 112 is affected. It's a git-svn clone and
even recreated copies out of svn do trigger the same failure.

Git mailing list ran out of ideas and for me this looks like some very
rare kernel issue. I'm not a kernel hacker. And to raise the challenge:
I can't share the repo easily, either.

Any hints how to tackle this issue?

Thanks!
- Ben


I'm not subscribed. Can you please CC me on replies?
