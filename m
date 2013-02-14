Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955Ab3BNRWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:22:06 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:37591 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab3BNRWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:22:03 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApZAAEAcHVFV5qjOPGdsb2JhbABEhgOEfbVpFwMBAQEBODSCHwEBBAE6HCMQCAMOEyUPBSUKGogfCr1KFZEOYQOWI4YBjVs
X-IronPort-AV: E=Sophos;i="4.84,666,1355094000"; 
   d="scan'208";a="277177392"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 14 Feb 2013 18:22:43 +0100
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chung-Yih Wang <cywang@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - disable fuzz when using mt slots
Message-ID: <20130214172243.GB538@polaris.bitmath.org>
References: <1359707312-12986-1-git-send-email-djkurtz@chromium.org>
 <20130213215250.GE23390@core.coreip.homeip.net>
 <CAGS+omDJi6EecXHdtYEGg0iXNqTLSnhHPE7ieHQ=ZNXkowJqKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omDJi6EecXHdtYEGg0iXNqTLSnhHPE7ieHQ=ZNXkowJqKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hmm, instead of disabling fuzz completely maybe we should disable it
> > only on the derived axes (ABS_X/ABS_Y) for multitouch devices?
> 
> Yes, that should work...  both would end up fuzzed to the same value,
> for a not-so-obvious reason, IMHO :).
> It's a bit tricky, and I like it, but is that what you intended by the
> suggestion?

Since this is inherently a problem when using the mt helper functions,
turning fuzz off there ought to solve this problem transparently, and
for all users.

Thanks, Daniel, for reminding me of this year-old glitch. :-)

Henrik
