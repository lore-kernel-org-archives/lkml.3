Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3GJB0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 21:26:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:43228 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3GJB0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 21:26:10 -0400
X-Spam-Score: -100.8
Message-ID: <51DCB336.5040405@asianux.com>
Date: Wed, 10 Jul 2013 09:04:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Information] gcc '-O2' may skip some of uninitialized variables
 warnings (exist almost 10 years).
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hell All:

gcc '-O2' may skip some of uninitialized variables warnings which may be
real bugs. This is gcc issue which keep existence almost 10 years, and
now it seems can not be fixed in recent years.

Please reference: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=18501, for
kernel special case, also can reference:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=57856

If we want to see the warnings (for finding bugs), "EXTRA_CFLAGS=-W"
seems not enough (it use '-O2'), I recommend also to try '-O0' (although
it may also print many spurious warnings)


Thanks.
-- 
Chen Gang
