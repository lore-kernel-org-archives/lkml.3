Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494AbaJUUKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:10:50 -0400
Received: from lists.s-osg.org ([54.187.51.154]:41603 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666AbaJUUKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:10:48 -0400
Message-ID: <5446BDC6.4040502@osg.samsung.com>
Date: Tue, 21 Oct 2014 14:10:46 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: rt-tester - move under selftests
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew/Ingo/Thomas,

You are all on the signed-off list for rt-tester. I have been poking
around the source tree looking for existing test and came across rt-tester.

What are your thoughts on rt-tester suitability to reside under
tools/testing/selftest and becoming part of kselftest target?
Would you like see it moved under the kselftest umbrella?

thanks,
-- Shuah
-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
