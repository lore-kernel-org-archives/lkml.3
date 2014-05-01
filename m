Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaEAVvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:51:42 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58517 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaEAVvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:51:41 -0400
Date: Thu, 1 May 2014 23:51:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
Message-ID: <20140501215139.GI2382@two.firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-5-git-send-email-andi@firstfloor.org>
 <535FED4D.5000703@amacapital.net>
 <20140429233950.GE2382@two.firstfloor.org>
 <53608180.5070800@zytor.com>
 <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com>
 <20140501211554.GH2382@two.firstfloor.org>
 <CALCETrXFO3Y5iVxn_J0-8h=sEU9TFbBk6F3J7dRXu+b0HsBE=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXFO3Y5iVxn_J0-8h=sEU9TFbBk6F3J7dRXu+b0HsBE=A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Allowing userspace to prevent itself from being rescheduled by loading
> something strange into gsbase seems unfortunate.

The timer tick will eventually catch it, so any delay is tightly
bounded.

Also still gets rescheduled most of the time, just not when a paranoid 
exception handler is running.

-Andi
