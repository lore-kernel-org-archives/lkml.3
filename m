Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3HFPSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:18:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:55552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab3HFPSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:18:23 -0400
Message-ID: <1375802297.8219.25.camel@jlt4.sipsolutions.net>
Subject: Re: linux-next: Tree for Aug 6 [ wireless | iwlwifi | mac80211 ? ]
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wireless <linux-wireless@vger.kernel.org>
Date: Tue, 06 Aug 2013 17:18:17 +0200
In-Reply-To: <CA+icZUWijPJmNoqE22Msqcn7tRot3SB3e=KujMM7JNd-Om-oOw@mail.gmail.com> (sfid-20130806_170953_045100_849D0912)
References: <CA+icZUX8OcTSOABO6Nbz5R6_5-m39rsYOpDqYBA7hf8LFvJLLA@mail.gmail.com>
	 <1375797260.8219.21.camel@jlt4.sipsolutions.net>
	 <CA+icZUUAJ25QybqHvxz7eubSLH6YuNjcc5zyU2O5Xi9vevMGkw@mail.gmail.com>
	 <1375800617.8219.23.camel@jlt4.sipsolutions.net>
	 <CA+icZUVbKpyuke6PRg3-60gOggsTb=3cNRz3Sy0RmvcZSuPaNw@mail.gmail.com>
	 <1375801059.8219.24.camel@jlt4.sipsolutions.net>
	 <CA+icZUXrRsXfeW9hqxTMkKW4TdNSBH-zE8-zX2Rd7HTAx5MvqQ@mail.gmail.com>
	 <CA+icZUWijPJmNoqE22Msqcn7tRot3SB3e=KujMM7JNd-Om-oOw@mail.gmail.com>
	 (sfid-20130806_170953_045100_849D0912)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> I have sent you a v2 of my logs (with -d and rsyslog-7.x).

Hmm, that looks different? There no longer is anything about "PSK might
be wrong", but now just disconnections by the AP, which unfortunately
indicate no reason.

When was it working last?

johannes

