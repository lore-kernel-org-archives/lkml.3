Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaLITWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:22:54 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:58236 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbaLITWw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:22:52 -0500
From: "Young, David" <dayoung@akamai.com>
To: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 9 Dec 2014 14:22:42 -0500
Subject: selftests: question about git repos containing selftest.
Thread-Topic: selftests: question about git repos containing selftest.
Thread-Index: AdAT5PEHC0nq6vfwS4WLO5lgc0LomQ==
Message-ID: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I'm trying out the new kernel selftests and was looking for the "bleeding edge" repository to clone.  According to the wiki https://kselftest.wiki.kernel.org/ this is the appropriate repo:
git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git

However, I am finding newer and more frequent changes are in linux-next.
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Which should I clone for the most fresh changes?

-David Young
