Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaBIUPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:15:31 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:56873 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbaBIUPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:15:30 -0500
Message-ID: <1391976929.25855.22.camel@x220>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:15:29 +0100
In-Reply-To: <52F7DF51.8000507@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
		 <1391971686-9517-25-git-send-email-richard@nod.at>
	 <1391974709.25855.3.camel@x220> <52F7DF51.8000507@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:15:29.0922 (UTC) FILETIME=[ADADF620:01CF25D3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 21:04 +0100, Richard Weinberger wrote:
> Am 09.02.2014 20:38, schrieb Paul Bolle:
> > But now you've enabled a lot of stuff that, as far as I can tell, could
> > not have been built since v2.6.39.
> 
> This is by design. If the code does not build/work it needs to be fixed or removed.

If that was the design goal of this patch (and similar patches you've
sent) it would have been proper to at least say a few words along those
lines in the commit explanation.


Paul Bolle

