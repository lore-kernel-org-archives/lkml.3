Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaDOJNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:13:18 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:63881 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbaDOJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:13:16 -0400
Message-ID: <1397553194.1985.23.camel@x220>
Subject: Re: [PATCH 18/28] Remove MN10300_PROC_MN2WS0038
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>
Cc: Richard Weinberger <richard@nod.at>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 11:13:14 +0200
In-Reply-To: <1098.1392044308@warthog.procyon.org.uk>
References: <1391971686-9517-19-git-send-email-richard@nod.at>
	 <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1098.1392044308@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 09:13:14.0786 (UTC) FILETIME=[EE8B2020:01CF588A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 14:58 +0000, David Howells wrote:
> Richard Weinberger <richard@nod.at> wrote:
> 
> > The symbol is an orphan, get rid of it.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Acked-by: David Howells <dhowells@redhat.com>

I don't think this oneliner is queued somewhere. David, you're listed as
one of the mn10300 maintainers: could you perhaps queue this patch?


Paul Bolle

