Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaHKGly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 02:41:54 -0400
Received: from sam.nabble.com ([216.139.236.26]:54492 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaHKGlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 02:41:53 -0400
Date: Sun, 10 Aug 2014 23:41:53 -0700 (PDT)
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1407739313377-921802.post@n7.nabble.com>
In-Reply-To: <CA+55aFww-UYfLA4cN6MSkeXzmAnAruShddAPegCpn+5yd1HGmQ@mail.gmail.com>
References: <6402.1369320636@warthog.procyon.org.uk> <CA+55aFww-UYfLA4cN6MSkeXzmAnAruShddAPegCpn+5yd1HGmQ@mail.gmail.com>
Subject: Re: Is spin_is_locked() safe to use with BUG_ON()/WARN_ON()?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I think still this is not being replaced with assert_spin_lock_held() call
as suggested by Linus.It is worth to replace these calls.

Sanjeev Sharma



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/Is-spin-is-locked-safe-to-use-with-BUG-ON-WARN-ON-tp654800p921802.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
