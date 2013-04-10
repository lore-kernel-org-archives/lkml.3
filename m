Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937092Ab3DJRzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:55:55 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:58405 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936082Ab3DJRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:55:53 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 10 Apr 2013 10:55:31 -0700
X-Google-Sender-Auth: oD-Y2v7sSqyKN3FhL18fXR1i0SA
Message-ID: <CAB=NE6XH8wGbFhmB54Y0BUB2N-PbzUBvN+arH5F_BAkEa=DjUw@mail.gmail.com>
Subject: Jitter and latency benchmarks with netlink / nl80211
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Curious if anyone has worked on latency and jitter benchmarks in using
netlink, specifically with nl80211. Has anyone benchmarked this? Ben,
have you? If not for nl80211 perhaps this has been done before for
other netlink families?

  Luis
