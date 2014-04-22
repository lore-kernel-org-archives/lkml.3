Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaDVX2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:28:06 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:57610 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaDVX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:28:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Vgvyf-WYwE-9+RjY3RA7kYuX6P=onrgJE6rLwt4c7Y5Q@mail.gmail.com>
References: <20140419031554.253c98c3@xenia.leun.net> <20140419213254.0b4c4b6a@xenia.leun.net>
 <CAB=NE6Vgvyf-WYwE-9+RjY3RA7kYuX6P=onrgJE6rLwt4c7Y5Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 16:27:42 -0700
X-Google-Sender-Auth: VQ57_edVWlJdkbBiazRTZYakkkE
Message-ID: <CAB=NE6VAy==e17dF1aXbmBAwdDSSo4R+8D2wjyEBj33eZFtQxw@mail.gmail.com>
Subject: Re: 3.14 Regression, kernel panic when suspend, looks ath9k /
 wireless related
To: Michael Leun <lkml20140418@newton.leun.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k mailing list <ath9k-devel@venema.h4ckr.net>,
        Mihir Shete <smihir@qti.qualcomm.com>,
        Henri Bahini <hbahini@qca.qualcomm.com>,
        Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch has been sent to stable that fixes this, the patch is already
upstream fortunately.

  Luis
