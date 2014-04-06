Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaDFUw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:52:59 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:60548 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbaDFUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:52:57 -0400
Message-ID: <1396817575.4886.23.camel@x220>
Subject: Re: Kconfig circular dependency question
From: Paul Bolle <pebolle@tiscali.nl>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 06 Apr 2014 22:52:55 +0200
In-Reply-To: <5341B999.3050206@infradead.org>
References: <5341AFC7.1070001@lwfinger.net> <5341B999.3050206@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 20:52:56.0147 (UTC) FILETIME=[2FAAB230:01CF51DA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 13:31 -0700, Randy Dunlap wrote:
> and/or changing MOUSE_APPLETOUCH to depend on USB instead of select it?

MOUSE_APPLETOUCH selects USB and depends on USB_ARCH_HAS_HCD. That's
actually quite a common pattern.

But what is the purpose of USB_ARCH_HAS_HCD? It is set by default if
USB_SUPPORT is set. And USB depends on it, but since USB also depends on
USB_SUPPORT that seems superfluous.

My slow day continues, because I find this hard to grok.


Paul Bolle

