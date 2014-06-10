Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaFJJIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:08:34 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:37565 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbaFJJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:08:21 -0400
X-Yandex-Uniq: 891dcd13-be7f-44c5-871b-ff43953c4e91
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 10 Jun 2014 13:08:14 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@gmail.com>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf timechart: implement IO mode
Message-ID: <20140610090814.GM26511@stfomichev-desktop.yandex.net>
References: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
 <1402305672-2630-3-git-send-email-stfomichev@yandex-team.ru>
 <8738fdb3uc.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738fdb3uc.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then I stopped to test/review.  I'll review if you send v2 with fixes.
Oops, sorry, I've sent an old version. Will come back with v2 and
will split --io-xyz options.
